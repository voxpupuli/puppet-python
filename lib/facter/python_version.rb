# Make python versions available as facts
# In lists default python and system python versions
require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "python")

Facter.add("system_python_version") do
  setcode do
    if pkg.retrieve[pkg.property(:ensure)] != 'purged'
        /^(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
    end
  end
end

Facter.add("python_version") do
  has_weight 100
  setcode do
    /^.*(\d+\.\d+\.\d+)$/.match(Facter::Util::Resolution.exec('python -V'))[1]
  end
end

Facter.add("python_version") do
  has_weight 50
  setcode do
    if pkg.retrieve[pkg.property(:ensure)] != 'purged'
        /^.*(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
    end
  end
end
