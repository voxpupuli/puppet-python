# frozen_string_literal: true

require 'spec_helper'

describe 'python::pyvenv', type: :define do
  on_supported_os.each do |os, facts|
    next if os == 'gentoo-3-x86_64'

    context "on #{os}" do
      let :facts do
        # python3 is required to use pyvenv
        facts.merge(
          python3_version: '3.5.1'
        )
      end
      let :title do
        '/opt/env'
      end

      context 'with default parameters' do
        it { is_expected.to contain_file('/opt/env').that_requires('Class[python::install]') }
        it { is_expected.to contain_exec('python_virtualenv_/opt/env').with_command('pyvenv-3.5 --clear   /opt/env && /opt/env/bin/pip --log /opt/env/pip.log install  --upgrade pip && /opt/env/bin/pip --log /opt/env/pip.log install  --upgrade setuptools') }
      end

      describe 'when ensure' do
        context 'is absent' do
          let :params do
            {
              ensure: 'absent'
            }
          end

          it {
            expect(subject).to contain_file('/opt/env').with_ensure('absent').with_purge(true)
          }
        end
      end
    end

    context "prompt on #{os} with python 3.6" do
      let :facts do
        # python 3.6 is required for venv and prompt
        facts.merge(
          python3_version: '3.6.1'
        )
      end
      let :title do
        '/opt/env'
      end

      context 'with prompt' do
        let :params do
          {
            prompt: 'custom prompt',
          }
        end

        it {
          is_expected.to contain_file('/opt/env').that_requires('Class[python::install]')
          is_expected.to contain_exec('python_virtualenv_/opt/env').with_command('python3.6 -m venv --clear  --prompt custom\\ prompt /opt/env && /opt/env/bin/pip --log /opt/env/pip.log install  --upgrade pip && /opt/env/bin/pip --log /opt/env/pip.log install  --upgrade setuptools')
        }
      end
    end

    context "prompt on #{os} with python 3.5" do
      let :facts do
        facts.merge(
          python3_version: '3.5.1'
        )
      end
      let :title do
        '/opt/env'
      end

      context 'with prompt' do
        let :params do
          {
            prompt: 'custom prompt',
          }
        end

        it {
          is_expected.to contain_file('/opt/env').that_requires('Class[python::install]')
          is_expected.to contain_exec('python_virtualenv_/opt/env').with_command('pyvenv-3.5 --clear   /opt/env && /opt/env/bin/pip --log /opt/env/pip.log install  --upgrade pip && /opt/env/bin/pip --log /opt/env/pip.log install  --upgrade setuptools')
        }
      end
    end
  end
end
