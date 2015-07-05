# Make python versions available as facts

Facter.add("python_version") do
  setcode do
    if Facter::Util::Resolution.which('python')
      Facter::Util::Resolution.exec('python -V 2>&1').match(/^.*(\d+\.\d+\.\d+)$/)[1]
    end
  end
end
