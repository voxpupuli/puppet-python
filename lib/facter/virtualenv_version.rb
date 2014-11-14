# Make virtualenv version available as a fact
# Works with virualenv loaded and without, pip installed and package installed
require 'puppet'
require 'rubygems'

facter_puppet_version = Facter.value(:puppetversion)
facter_is_pe = Facter.value(:is_pe)

if facter_is_pe
    facter_puppet_version = facter_puppet_version.to_s.split(' ')[0]
end

if Gem::Version.new(facter_puppet_version) >= Gem::Version.new('3.6')
  pkg = Puppet::Type.type(:package).new(:name => 'virtualenv', :allow_virtual => 'false')
else
  pkg = Puppet::Type.type(:package).new(:name => 'virtualenv')
end
Facter.add("virtualenv_version") do
  has_weight 100
  setcode do
    begin
      Facter::Util::Resolution.exec('virtualenv --version') || "absent"
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
