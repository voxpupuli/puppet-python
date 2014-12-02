# Make pip version available as a fact
# Works with pip loaded and without, pip installed using pip  and package installed
require 'puppet'
require 'rubygems'

facter_puppet_version = Facter.value(:puppetversion)
facter_is_pe = Facter.value(:is_pe)

if facter_is_pe
    facter_puppet_version = facter_puppet_version.to_s.split(' ')[0]
end

if Gem::Version.new(facter_puppet_version) >= Gem::Version.new('3.6')
  pkg = Puppet::Type.type(:package).new(:name => 'python-pip', :allow_virtual => 'false')
else
  pkg = Puppet::Type.type(:package).new(:name => 'python-pip')
end
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
