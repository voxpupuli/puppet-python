require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts
add_custom_fact :id, 'root'
add_custom_fact :kernel, 'Linux'
add_custom_fact :concat_basedir, '/dne'
add_custom_fact :path, '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
add_custom_fact :lsbdistcodename, 'squeeze', :confine => 'debian-6-x86_64'
add_custom_fact :lsbdistcodename, 'nil', :confine => 'sles-11.3-x86_64'
