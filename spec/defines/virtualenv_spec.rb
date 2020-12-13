require 'spec_helper'

describe 'python::virtualenv', type: :define do
  on_supported_os.each do |os, facts|
    next if os == 'gentoo-3-x86_64'
    context "on #{os}" do
      let :facts do
        facts
      end
      let :title do
        '/opt/env'
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/opt/env') }
        it { is_expected.to contain_exec('python_virtualenv_/opt/env').with_command('virtualenv --no-site-packages -p python /opt/env && /opt/env/bin/pip --log /opt/env/pip.log install  --proxy=  --upgrade pip && /opt/env/bin/pip install  --proxy=  --upgrade distribute') }
      end

      context 'when virtualenv is defined' do
        let(:params) {{ virtualenv: 'virtualenv-3' }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('python_virtualenv_/opt/env').with_command(%r{virtualenv-3 --no-site-packages -p python .+}) }
      end

      describe 'when ensure' do
        context 'is absent' do
          let :params do
            {
              ensure: 'absent'
            }
          end

          it {
            is_expected.to contain_file('/opt/env').with_ensure('absent').with_purge(true)
          }
        end
      end
    end # context
  end
end
