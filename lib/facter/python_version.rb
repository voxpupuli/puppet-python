# Make python versions available as facts
# In lists default python and system python versions

facter_puppet_version = Facter.value(:puppetversion)
facter_is_pe = Facter.value(:is_pe)

if facter_is_pe
  facter_puppet_version = facter_puppet_version.to_s.split(' ')[0]
end

if (Puppet::Util::Package.versioncmp(facter_puppet_version, '3.6') >= 0)
  pkg = Puppet::Type.type(:package).new(:name => 'python-pip', :allow_virtual => 'false')
else
  pkg = Puppet::Type.type(:package).new(:name => 'python-pip')
end

Facter.add("system_python_version") do
  setcode do
    unless [:absent,:purged].include?(pkg.retrieve[pkg.property(:ensure)])
      pkg.retrieve[pkg.property(:ensure)]
    end
  end
end

Facter.add("python_version") do
  has_weight 100
  setcode do
    if Facter::Util::Resolution.which('python')
      Facter::Util::Resolution.exec('python -V 2>&1').match(/^.*(\d+\.\d+\.\d+)$/)[1]
    end
  end
end

Facter.add("python_version") do
  has_weight 50
  setcode do
    unless [:absent,:purged].include?(pkg.retrieve[pkg.property(:ensure)])
      pkg.retrieve[pkg.property(:ensure)]
    end
  end
end
