# frozen_string_literal: true

require 'spec_helper'

describe 'python::install::venv' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default settings' do
        if %w[Archlinux RedHat FreeBSD].include?(facts[:os]['family'])
          it { is_expected.not_to contain_package('python-venv') }
        else
          it { is_expected.to contain_package('python-venv').with(ensure: 'absent') }
        end
      end

      context 'when ensuring venv is setup' do
        let(:pre_condition) do
          <<~PP
            class { 'python':
              venv => present,
            }
          PP
        end

        if %w[Archlinux RedHat FreeBSD].include?(facts[:os]['family'])
          it { is_expected.not_to contain_package('python-venv') }
        else
          it { is_expected.to contain_package('python-venv').with(ensure: 'present') }
        end
      end
    end
  end
end
