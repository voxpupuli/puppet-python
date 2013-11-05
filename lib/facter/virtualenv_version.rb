# Make virtualenv version available as a fact
# Works with virualenv loaded and without, pip installed and package installed
require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "virtualenv")
Facter.add("virtualenv_version") do
  has_weight 100
  setcode do
    Facter::Util::Resolution.exec('virtualenv --version')
  end
end

Facter.add("virtualenv_version") do
  has_weight 50
  setcode do
    if pkg.retrieve[pkg.property(:ensure)] != 'purged'
        /^.*(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
    end
  end
end
