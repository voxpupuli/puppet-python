require 'spec_helper_acceptance'

describe 'python class' do
  context 'facts' do
    install_python = <<-EOS
      class { 'python' :
        version    => 'system',
        pip        => 'present',
        virtualenv => 'present',
      }
      EOS

    fact_notices = <<-EOS
      notify{"pip_version: ${facts['pip_version']}":}
      notify{"system_python_version: ${facts['system_python_version']}":}
      notify{"python_version: ${facts['python_version']}":}
      notify{"virtualenv_version: ${facts['virtualenv_version']}":}
      EOS

    # rubocop:disable RSpec/RepeatedExample
    it 'outputs python facts when not installed' do # rubocop:disable RSpec/MultipleExpectations
      apply_manifest(fact_notices, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{python_version: \S+})
        expect(r.stdout).to match(%r{pip_version: \S+})
        expect(r.stdout).to match(%r{virtualenv_version: \S+})
        expect(r.stdout).to match(%r{system_python_version: \S+})
      end
    end

    it 'sets up python' do
      apply_manifest(install_python, catch_failures: true)
    end

    it 'outputs python facts when installed' do # rubocop:disable RSpec/MultipleExpectations
      apply_manifest(fact_notices, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{python_version: \S+})
        expect(r.stdout).to match(%r{pip_version: \S+})
        expect(r.stdout).to match(%r{virtualenv_version: \S+})
        expect(r.stdout).to match(%r{system_python_version: \S+})
      end
    end
    # rubocop:enable RSpec/RepeatedExample
  end
end
