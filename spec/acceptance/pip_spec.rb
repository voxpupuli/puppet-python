require 'spec_helper_acceptance'

describe 'python::pip defined resource' do
  context 'install package with custom name' do
    it 'works with no errors' do
      pp = <<-PUPPET
      class { 'python':
        version => '3',
        dev     => 'present',
      }

      python::pip { 'agent package':
        pkgname => 'agent'
        ensure  => '0.1.2'
      }
      PUPPET

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
  end
  describe command('/opt/agent/venv/bin/pip list') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{agent.* 0\.1\.2} }
  end
end

