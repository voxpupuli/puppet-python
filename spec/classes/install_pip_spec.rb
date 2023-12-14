# frozen_string_literal: true

require 'spec_helper'

describe 'python::install::pip' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default settings' do
        it { is_expected.to contain_package('pip').with(ensure: 'present') }
      end

      context 'when ensuring pip is absent' do
        let(:pre_condition) do
          <<~PP
            class { 'python':
              pip => absent,
            }
          PP
        end

        it { is_expected.to contain_package('pip').with(ensure: 'absent') }
      end
    end
  end
end
