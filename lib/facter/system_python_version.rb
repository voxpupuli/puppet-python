require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "python")
Facter.add("system_python_version") do
  setcode do
    /^(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
  end
end
