# frozen_string_literal: true

require 'spec_helper'
# rubocop:disable RSpec/MultipleDescribes
# rubocop:disable RSpec/RepeatedExampleGroupDescription
describe 'python::pip', type: :define do
  let(:title) { 'rpyc' }

  context 'on Debian OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        lsbdistcodename: 'squeeze',
        os: {
          family: 'Debian',
          release: { major: '6' },
        },
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '6',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        concat_basedir: '/dne',
        pip_version: '18.1'
      }
    end

    describe 'virtualenv as' do
      context 'fails with non qualified path' do
        let(:params) { { virtualenv: 'venv' } }

        it { is_expected.to raise_error(%r{expects a match for Variant\[Enum\['system'\].*Stdlib::Windowspath = Pattern\[/.*/\], Stdlib::Unixpath = Pattern\[/.*/\]\]}) }
      end

      context 'suceeds with qualified path' do
        let(:params) { { virtualenv: '/opt/venv' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_cwd('/opt/venv') }
      end

      context 'defaults to system' do
        let(:params) { {} }

        it { is_expected.to contain_exec('pip_install_rpyc').with_cwd('/') }
      end
    end

    describe 'pip_provide as' do
      context 'defaults to pip' do
        let(:params) { {} }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command(%r{pip}) }
        it { is_expected.not_to contain_exec('pip_install_rpyc').with_command(%r{pip3}) }
      end

      context 'use pip instead of pip3 when specified' do
        let(:params) { { pip_provider: 'pip' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command(%r{pip}) }
        it { is_expected.not_to contain_exec('pip_install_rpyc').with_command(%r{pip3}) }
      end

      context 'use pip3 instead of pip when specified' do
        let(:params) { { pip_provider: 'pip3' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command(%r{pip3}) }
      end
    end

    describe 'proxy as' do
      context 'defaults to empty' do
        let(:params) { {} }

        it { is_expected.not_to contain_exec('pip_install_rpyc').with_command(%r{--proxy}) }
      end

      context 'adds proxy to install command if proxy set' do
        let(:params) { { proxy: 'http://my.proxy:3128' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command('pip --log /tmp/pip.log install    --proxy=http://my.proxy:3128  rpyc') }
      end
    end

    describe 'index as' do
      context 'defaults to empty' do
        let(:params) { {} }

        it { is_expected.not_to contain_exec('pip_install_rpyc').with_command(%r{--index-url}) }
      end

      context 'adds index to install command if index set' do
        let(:params) { { index: 'http://www.example.com/simple/' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command('pip --log /tmp/pip.log install  --index-url=http://www.example.com/simple/    rpyc') }
      end
    end

    describe 'extra_index as' do
      context 'defaults to empty' do
        let(:params) { {} }

        it { is_expected.not_to contain_exec('pip_install_rpyc').with_command(%r{--extra-index-url}) }
      end

      context 'adds extra_index to install command if extra_index set' do
        let(:params) { { extra_index: 'http://www.example.com/extra/simple/' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command('pip --log /tmp/pip.log install   --extra-index-url=http://www.example.com/extra/simple/   rpyc') }
      end
    end

    describe 'path as' do
      context 'adds anaconda path to pip invocation if provider is anaconda' do
        let(:params) { {} }
        let(:pre_condition) { 'class {"python": provider => "anaconda", anaconda_install_path => "/opt/python3"}' }

        it { is_expected.to contain_exec('pip_install_rpyc').with_path(['/opt/python3/bin', '/usr/local/bin', '/usr/bin', '/bin', '/usr/sbin']) }
      end
    end

    describe 'install_args as' do
      context 'adds install_args to install command if install_args set' do
        let(:params) { { install_args: '--pre' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command('pip --log /tmp/pip.log install --pre     rpyc') }
      end
    end

    describe 'install latest' do
      context 'does not use legacy resolver in unless' do
        let(:params) { { ensure: 'latest' } }

        it { is_expected.not_to contain_exec('pip_install_rpyc').with_unless(%r{--use-deprecated=legacy-resolver}) }
      end

      context 'does not use pip search in unless' do
        let(:params) { { ensure: 'latest' } }

        it { is_expected.not_to contain_exec('pip_install_rpyc').with_unless(%r{search}) }
      end

      context 'checks installed version of a package by converting underscores in its name to dashes' do
        let(:params) { { ensure: 'latest', pkgname: 'wordpress_json' } }

        # yes, the exec title does not change if we use different pgkname
        it { is_expected.to contain_exec('pip_install_rpyc').with_unless(%r{wordpress-json}) }
      end
    end

    describe 'install specific version' do
      context 'supports v-prefixed version string' do
        let(:params) { { ensure: 'v1.7.0' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command('pip --log /tmp/pip.log install      rpyc==v1.7.0') }
      end

      context 'supports version string without v-prefix' do
        let(:params) { { ensure: '1.7.0' } }

        it { is_expected.to contain_exec('pip_install_rpyc').with_command('pip --log /tmp/pip.log install      rpyc==1.7.0') }
      end
    end

    describe 'uninstall' do
      context 'adds correct title' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.not_to contain_exec('pip_install_rpyc') }

        it { is_expected.to contain_exec('pip_uninstall_rpyc').with_command(%r{uninstall.*rpyc$}) }
      end

      context 'passes correct package name' do
        let(:params) { { ensure: 'absent', pkgname: 'r-pyc' } }

        it { is_expected.not_to contain_exec('pip_install_rpyc') }

        it { is_expected.to contain_exec('pip_uninstall_rpyc').with_command(%r{uninstall.*r-pyc$}) }
      end
    end
  end

  context 'on Debian OS with pip_version 20.3.4' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        lsbdistcodename: 'buster',
        os: {
          family: 'Debian',
          release: { major: '10' },
        },
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '10.12',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        concat_basedir: '/dne',
        pip_version: '20.3.4'
      }
    end

    describe 'install latest' do
      context 'with legacy resolver in unless cmd' do
        let(:params) { { ensure: 'latest' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('pip_install_rpyc').with_unless(%r{--use-deprecated=legacy-resolver}) }
      end
    end
  end
end

describe 'python::pip', type: :define do
  # rubocop:enable RSpec/RepeatedExampleGroupDescription
  let(:title) { 'requests' }

  context 'on Debian OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        lsbdistcodename: 'squeeze',
        os: {
          family: 'Debian'
        },
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '6',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        concat_basedir: '/dne'
      }
    end

    describe 'extras as' do
      context 'suceeds with no extras' do
        let(:params) { {} }

        it { is_expected.to contain_exec('pip_install_requests').with_command('pip --log /tmp/pip.log install      requests') }
      end

      context 'succeeds with extras' do
        let(:params) { { extras: ['security'] } }

        it { is_expected.to contain_exec('pip_install_requests').with_command('pip --log /tmp/pip.log install      requests[security]') }
      end
    end
  end
end
# rubocop:enable RSpec/MultipleDescribes
