require 'spec_helper'

describe 'python::dotfile', type: :define do
  on_supported_os.each do |os, facts|
    context("on #{os} ") do
      let :facts do
        facts
      end

      describe 'dotfile as' do
        context 'fails with empty string filename' do
          let(:title) { '' }

          it { is_expected.to raise_error(%r{Evaluation Error: Empty string title at 0. Title strings must have a length greater than zero.}) }
        end
        context 'fails with incorrect mode' do
          let(:title) { '/etc/pip.conf' }
          let(:params) { { mode: 'not-a-mode' } }

          it { is_expected.to raise_error(%r{Evaluation Error: Error while evaluating a Resource}) }
        end
        context 'succeeds with filename in existing path' do
          let(:title) { '/etc/pip.conf' }

          it { is_expected.to contain_file('/etc/pip.conf').with_mode('0644') }
        end
        context 'succeeds with filename in a non-existing path' do
          let(:title) { '/home/someuser/.pip/pip.conf' }

          it { is_expected.to contain_exec('create /home/someuser/.pip/pip.conf\'s parent dir').with_command('install -o root -g root -d /home/someuser/.pip') }
          it { is_expected.to contain_file('/home/someuser/.pip/pip.conf').with_mode('0644') }
        end
        context 'succeeds when set owner' do
          let(:title) { '/home/someuser/.pip/pip.conf' }
          let(:params) { { owner: 'someuser' } }

          it { is_expected.to contain_exec('create /home/someuser/.pip/pip.conf\'s parent dir').with_command('install -o someuser -g root -d /home/someuser/.pip') }
          it { is_expected.to contain_file('/home/someuser/.pip/pip.conf').with_owner('someuser') }
        end
        context 'succeeds when set group set' do
          let(:title) { '/home/someuser/.pip/pip.conf' }
          let(:params) { { group: 'somegroup' } }

          it { is_expected.to contain_exec('create /home/someuser/.pip/pip.conf\'s parent dir').with_command('install -o root -g somegroup -d /home/someuser/.pip') }
          it { is_expected.to contain_file('/home/someuser/.pip/pip.conf').with_group('somegroup') }
        end
      end
    end
  end
end
