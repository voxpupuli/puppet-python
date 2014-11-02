# Make python versions available as facts
# In lists default python and system python versions
require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "python")

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
