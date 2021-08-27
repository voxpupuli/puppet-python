require 'spec_helper_acceptance'

describe 'requirements' do
  it 'checks declared requirements file is installed to venv' do
    pp = <<-EOS
    file { '/tmp/requirements.txt':
      ensure  => 'present',
      content => 'requests',
    }

    python::pyvenv { '/tmp/pyvenv':
      ensure  => 'present',
    }

    python::requirements { '/tmp/requirements.txt':
      virtualenv => '/tmp/pyvenv'
    }
    EOS

    apply_manifest(pp, catch_failures: true)

    expect(shell('/tmp/pyvenv/bin/pip3 list --no-index | grep requests').stdout).to match(%r{requests +\d+.\d+.\d+})
  end
end
