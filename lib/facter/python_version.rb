# Make python versions available as facts
# In lists default python and system python versions
require 'puppet'
require 'rubygems'

facter_puppet_version = Facter.value(:puppetversion)
facter_is_pe = Facter.value(:is_pe)

if facter_is_pe
    facter_puppet_version = facter_puppet_version.to_s.split(' ')[0]
end

if Gem::Version.new(facter_puppet_version) >= Gem::Version.new('3.6')
  pkg = Puppet::Type.type(:package).new(:name => 'python', :allow_virtual => 'false')
else
  pkg = Puppet::Type.type(:package).new(:name => 'python')
end
Facter.add("system_python_version") do
  setcode do
    begin
      unless [:absent,'purged'].include?(pkg.retrieve[pkg.property(:ensure)])
          /^(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
      end
    rescue
      false
    end
  end
end

Facter.add("python_version") do
  has_weight 100
  setcode do
    begin
      /^.*(\d+\.\d+\.\d+)$/.match(Facter::Util::Resolution.exec('python -V 2>&1'))[1]
    rescue
      false
    end
  end
end

Facter.add("python_version") do
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
