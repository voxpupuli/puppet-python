# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker(modules: :metadata) do |host|
  host.install_package('gnupg2') if fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 10
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
