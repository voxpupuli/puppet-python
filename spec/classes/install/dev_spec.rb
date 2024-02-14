# frozen_string_literal: true

require 'spec_helper'

describe 'python::install::dev' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default settings' do
        it { is_expected.to contain_package('python-dev').with(ensure: 'absent') }
      end

      context 'when ensuring dev is setup' do
        let(:pre_condition) do
          <<~PP
            class { 'python':
              dev => present,
            }
          PP
        end

        it { is_expected.to contain_package('python-dev').with(ensure: 'present') }
      end
    end
  end
end
