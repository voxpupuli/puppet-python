require 'spec_helper_acceptance'

describe 'python class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors' do
      pp = <<-EOS
      if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '16.04' {
        $version = '3'
      } else {
        $version = 'system'
      }
      class { 'python' :
        version    => $version,
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        version    => $version,
        systempkgs => false,
        venv_dir   => '/opt/venv',
      }
      -> python::pip { 'rpyc' :
        ensure     => '3.2.3',
        virtualenv => '/opt/venv',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it 'maintains pip version' do
      pp = <<-EOS
      if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '16.04' {
        $version = '3'
      } else {
        $version = 'system'
      }
      class { 'python' :
        version    => $version,
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        version    => $version,
        systempkgs => false,
        venv_dir   => '/opt/venv2',
      }
      -> python::pip { 'pip' :
        ensure     => '18.0',
        virtualenv => '/opt/venv2',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it 'works with ensure=>latest' do
      pp = <<-EOS
      if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '16.04' {
        $version = '3'
      } else {
        $version = 'system'
      }
      class { 'python' :
        version    => $version,
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        version    => $version,
        systempkgs => false,
        venv_dir   => '/opt/venv3',
      }
      -> python::pip { 'rpyc' :
        ensure     => 'latest',
        virtualenv => '/opt/venv3',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      # Of course this test will fail if between the applies a new version of the package will be released,
      # but probability of this happening is minimal, so it should be acceptable.
      apply_manifest(pp, catch_changes: true)
    end

    it 'works with ensure=>latest for package with underscore in its name' do
      pp = <<-EOS
       if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '16.04' {
        $version = '3'
      } else {
        $version = 'system'
      }
      class { 'python' :
        version    => $version,
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        version    => $version,
        systempkgs => false,
        venv_dir   => '/opt/venv4',
      }
      -> python::pip { 'int_date' :
        ensure     => 'latest',
        virtualenv => '/opt/venv4',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      # Of course this test will fail if between the applies a new version of the package will be released,
      # but probability of this happening is minimal, so it should be acceptable.
      apply_manifest(pp, catch_changes: true)
    end

    it 'works with editable=>true' do
      pp = <<-EOS
      if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '16.04' {
        $version = '3'
      } else {
        $version = 'system'
      }
      package{ 'git' :
        ensure => 'present',
      }
      -> class { 'python' :
        version    => $version,
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        version    => $version,
        systempkgs => false,
        venv_dir   => '/opt/venv5',
      }
      -> python::pip { 'rpyc' :
        ensure     => '4.1.0',
        url        => 'git+https://github.com/tomerfiliba/rpyc.git',
        editable   => true,
        virtualenv => '/opt/venv5',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it 'works with == in pkgname' do
      pp = <<-EOS
      if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '16.04' {
        $version = '3'
      } else {
        $version = 'system'
      }
      class { 'python' :
        version    => $version,
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        version    => $version,
        systempkgs => false,
        venv_dir   => '/opt/venv6',
      }
      -> python::pip { 'rpyc==4.1.0' :
        virtualenv => '/opt/venv6',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
