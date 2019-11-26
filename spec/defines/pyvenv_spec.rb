require 'spec_helper'

describe 'python::pyvenv', type: :define do
  on_supported_os.each do |os, facts|
    context("on #{os} ") do
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
        it { is_expected.to contain_file('/opt/env') }
        it { is_expected.to contain_exec('python_virtualenv_/opt/env').with_command('pyvenv-3.5 --clear  /opt/env') }

        if %w[xenial bionic cosmic disco jessie stretch buster].include?(facts[:lsbdistcodename])
          it { is_expected.to contain_package('python3.5-venv').that_comes_before('File[/opt/env]') }
        end
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
