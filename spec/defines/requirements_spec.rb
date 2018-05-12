require 'spec_helper'

describe 'python::requirements', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      let :title do
        '/requirements.txt'
      end

      context 'on Debian OS' do
        describe 'requirements as' do
          context '/requirements.txt' do
            let :params do
              {
                requirements: '/requirements.txt'
              }
            end

            it { is_expected.to contain_file('/requirements.txt').with_mode('0644') }
          end
          context '/requirements.txt' do
            let :params do
              {
                requirements: '/requirements.txt',
                manage_requirements: false
              }
            end

            it { is_expected.not_to contain_file('/requirements.txt') }
          end

          describe 'with owner' do
            context 'bob:bob' do
              let :params do
                {
                  owner: 'bob',
                  group: 'bob'
                }
              end

              it do
                expect do
                  is_expected.to compile
                end.to raise_error(%r{root user must be used when virtualenv is system})
              end
            end
          end

          describe 'with owner' do
            context 'default' do
              it { is_expected.to contain_file('/requirements.txt').with_owner('root').with_group('root') }
            end
          end
        end
      end
    end
  end
end
