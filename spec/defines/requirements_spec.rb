require 'spec_helper'

describe 'python::requirements', type: :define do
  on_supported_os.each do |os, facts|
    next if os == 'gentoo-3-x86_64'
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

      context 'default' do
        it { is_expected.to contain_file('/requirements.txt').with_owner('root').with_group('root') }
      end
    end
  end
end
