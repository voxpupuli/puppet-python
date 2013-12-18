# Make pip version available as a fact
# Works with pip loaded and without, pip installed using pip  and package installed
require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "python-pip")
Facter.add("pip_version") do
  has_weight 100
  setcode do
    Facter::Util::Resolution.exec('pip --version')
  end
end

Facter.add("pip_version") do
  has_weight 50
  setcode do
    if pkg.retrieve[pkg.property(:ensure)] != 'purged'
        /^.*(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
    end
  end
end
