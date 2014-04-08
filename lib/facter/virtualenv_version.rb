# Make virtualenv version available as a fact
# Works with virualenv loaded and without, pip installed and package installed
require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "virtualenv")
Facter.add("virtualenv_version") do
  has_weight 100
  setcode do
    begin
      Facter::Util::Resolution.exec('virtualenv --version')
    rescue
      false
    end
  end
end

Facter.add("virtualenv_version") do
  has_weight 50
  setcode do
    begin
      unless [:absent,'purged'].include?(pkg.retrieve[pkg.property(:ensure)])
          /^.*(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
      end
    rescue
      false
    end
  end
end
