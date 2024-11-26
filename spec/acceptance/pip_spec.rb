# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'python::pip defined resource' do
  context 'install package with custom name' do
    it 'works with no errors' do
      pp = <<-PUPPET
      class { 'python':
        dev => 'present',
      }

      python::pyvenv { '/opt/test-venv':
        ensure      => 'present',
        systempkgs  => false,
        mode        => '0755',
      }

      python::pip { 'agent package':
        virtualenv => '/opt/test-venv',
        pkgname    => 'agent',
        ensure     => '0.1.2',
      }
      PUPPET

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  # rubocop:disable RSpec/RepeatedExampleGroupDescription
  # rubocop:disable RSpec/RepeatedExampleGroupBody
  describe command('/opt/test-venv/bin/pip list') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{agent.* 0\.1\.2} }
  end

  context 'uninstall package with custom name' do
    it 'works with no errors' do
      pp = <<-PUPPET
      class { 'python':
        dev => 'present',
      }

      python::pyvenv { '/opt/test-venv':
        ensure      => 'present',
        systempkgs  => false,
        mode        => '0755',
      }

      python::pip { 'agent package install':
        ensure     => '0.1.2',
        pkgname    => 'agent',
        virtualenv => '/opt/test-venv',
      }

      python::pip { 'agent package uninstall custom pkgname':
        ensure  => 'absent',
        pkgname => 'agent',
        virtualenv => '/opt/test-venv',
        require => Python::Pip['agent package install'],
      }

      PUPPET

      apply_manifest(pp, catch_failures: true)
    end
  end

  describe command('/opt/test-venv/bin/pip list') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.not_to match %r{agent.* 0\.1\.2} }
  end

  context 'fails to install package with wrong version' do
    it 'throws an error' do
      pp = <<-PUPPET
      class { 'python':
        version => '3',
        dev     => 'present',
      }

      python::pyvenv { '/opt/test-venv':
        ensure      => 'present',
        systempkgs  => false,
        mode        => '0755',
      }

      python::pip { 'agent package':
        virtualenv => '/opt/test-venv',
        pkgname    => 'agent',
        ensure     => '0.1.33+2020-this_is_something-fun',
      }
      PUPPET

      result = apply_manifest(pp, expect_failures: true)
      expect(result.stderr).to contain(%r{returned 1 instead of one of})
    end
  end

  describe command('/opt/test-venv/bin/pip show agent') do
    its(:exit_status) { is_expected.to eq 1 }
  end

  context 'install package via extra_index' do
    it 'works with no errors' do
      pp = <<-PUPPET
      class { 'python':
        dev => 'present',
      }

      python::pyvenv { '/opt/test-venv':
        ensure      => 'present',
        systempkgs  => false,
        mode        => '0755',
      }

      python::pip { 'agent package via extra_index':
        virtualenv  => '/opt/test-venv',
        pkgname     => 'agent',
        index       => 'invalid',
        extra_index => 'https://pypi.org/simple',
        ensure      => '0.1.2',
      }
      PUPPET

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe command('/opt/test-venv/bin/pip list') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{agent.* 0\.1\.2} }
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody
  # rubocop:enable RSpec/RepeatedExampleGroupDescription
end
