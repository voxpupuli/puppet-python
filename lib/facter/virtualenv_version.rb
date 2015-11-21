# Make virtualenv version available as a fact

Facter.add("virtualenv_version") do
  setcode do
    if Facter::Util::Resolution.which('virtualenv')
      Facter::Util::Resolution.exec('virtualenv --version 2>/dev/null || echo 0.0.0').match(/^(\d+\.\d+\.?\d*).*$/)[0]
    end
  end
end
