require 'spec_helper_acceptance'

describe 'python class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors' do
      pp = <<-EOS
      class { 'python' :
        version    => 'system',
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        systempkgs => false,
        venv_dir   => '/opt/venv',
        owner      => 'root',
        group      => 'root',
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
      class { 'python' :
        version    => 'system',
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        systempkgs => false,
        venv_dir   => '/opt/venv2',
        owner      => 'root',
        group      => 'root',
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
      class { 'python' :
        version    => 'system',
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        systempkgs => false,
        venv_dir   => '/opt/venv3',
        owner      => 'root',
        group      => 'root',
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
      class { 'python' :
        version    => 'system',
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        systempkgs => false,
        venv_dir   => '/opt/venv4',
        owner      => 'root',
        group      => 'root',
      }
      -> python::pip { 'Randomized_Requests' :
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
      package{ 'git' :
        ensure => 'present',
      }
      -> class { 'python' :
        version    => 'system',
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        systempkgs => false,
        venv_dir   => '/opt/venv5',
        owner      => 'root',
        group      => 'root',
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
      class { 'python' :
        version    => 'system',
        pip        => 'present',
        virtualenv => 'present',
      }
      -> python::virtualenv { 'venv' :
        ensure     => 'present',
        systempkgs => false,
        venv_dir   => '/opt/venv6',
        owner      => 'root',
        group      => 'root',
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
