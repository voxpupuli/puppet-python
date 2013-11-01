require 'puppet'
pkg = Puppet::Type.type(:package).new(:name => "virtualenv")
Facter.add("virtualenv_version") do
  setcode do
    /^(\d+\.\d+\.\d+).*$/.match(pkg.retrieve[pkg.property(:ensure)])[1]
  end
end
