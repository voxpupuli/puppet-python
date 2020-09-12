# This file is completely managed via modulesync
require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
