source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :system_tests do
  gem 'serverspec',              :require => false
  gem 'beaker',                  :require => false
  gem 'beaker-rspec',            :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

gem 'puppetlabs_spec_helper', '>= 1.2.0', :require => false
gem 'rspec-puppet', :require => false
gem 'puppet-lint', '~> 2.0', :require => false
gem 'simplecov', :require => false

gem 'rspec',     '~> 2.0', :require => false          if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'rake',      '~> 10.0', :require => false         if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'json',      '<= 1.8', :require => false          if RUBY_VERSION < '2.0.0'
gem 'json_pure', '<= 2.0.1', :require => false        if RUBY_VERSION < '2.0.0'
gem 'metadata-json-lint', '0.0.11', :require => false if RUBY_VERSION < '1.9'
gem 'metadata-json-lint', :require => false           if RUBY_VERSION >= '1.9'

# vim:ft=ruby
