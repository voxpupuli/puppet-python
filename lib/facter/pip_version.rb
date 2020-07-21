# Make pip version available as a fact

def get_pip_version(executable)
  if Facter::Util::Resolution.which(executable) # rubocop:disable Style/GuardClause
    results = Facter::Util::Resolution.exec("#{executable} --version 2>&1").match(%r{^pip (\d+\.\d+\.?\d*).*$})
    results[1] if results
  end
end

Facter.add('pip_version') do
  setcode do
    get_pip_version 'pip'
  end
end

Facter.add('pip2_version') do
  setcode do
    get_pip_version 'pip2'
  end
end

Facter.add('pip3_version') do
  setcode do
    get_pip_version 'pip3'
  end
end
