# Make pip version available as a fact
# Works with pip loaded and without, pip installed using pip  and package installed
require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "python-pip")
Facter.add("pip_version") do
  has_weight 100
  setcode do
    begin
      /^pip (\d+\.\d+\.?\d*).*$/.match(Facter::Util::Resolution.exec('pip --version 2>/dev/null'))[1]
    rescue
      false
    end
  end
end

Facter.add("pip_version") do
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
