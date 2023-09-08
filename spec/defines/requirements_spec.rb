# frozen_string_literal: true

require 'spec_helper'

describe 'python::requirements', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :title do
        '/requirements.txt'
      end

      context 'with /requirements.txt' do
        let :params do
          {
            requirements: '/requirements.txt'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/requirements.txt').with_mode('0644') }

        context 'with manage_requirements => false' do
          let(:params) { super().merge(manage_requirements: false) }

          it { is_expected.not_to contain_file('/requirements.txt') }
        end
      end

      describe 'with owner' do
        context 'bob:bob' do
          let :params do
            {
              owner: 'bob',
              group: 'bob'
            }
          end

          it { is_expected.to compile.and_raise_error(%r{root user must be used when virtualenv is system}) }
        end
      end

      context 'without parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('python::config') }
        it { is_expected.to contain_class('python::install') }
        it { is_expected.to contain_class('python::params') }
        it { is_expected.to contain_class('python') }
        it { is_expected.to contain_exec('python_requirements/requirements.txt') }

        if facts[:os]['family'] == 'Archlinux'
          it { is_expected.not_to contain_package('pip') }
        else
          it { is_expected.to contain_package('pip') }
        end
        it { is_expected.to contain_package('python') }
        it { is_expected.to contain_package('gunicorn') }
        it { is_expected.to contain_file('/requirements.txt').with_owner('root').with_group('root') }

        if %w[Archlinux FreeBSD Gentoo].include?(facts[:os]['name'])
          it { is_expected.not_to contain_package('python-dev') }
        else
          it { is_expected.to contain_package('python-dev') }
        end
      end
    end
  end
end
