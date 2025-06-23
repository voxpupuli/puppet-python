# frozen_string_literal: true

require 'spec_helper'

describe 'python::gunicorn', type: :define do
  let(:title) { 'test-app' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'test-app with default parameter values' do
        context 'configures test app with default parameter values' do
          let(:params) { { dir: '/srv/testapp' } }
          let(:expected_workers) do
            # templates/gunicorn.erb
            (facts[:processorcount].to_i * 2) + 1
          end

          it { is_expected.to contain_file('/etc/gunicorn.d/test-app').with_mode('0644').with_content(%r{--log-level=error}) }
          it { is_expected.to contain_file('/etc/gunicorn.d/test-app').with_mode('0644').with_content(%r{--workers=#{expected_workers}}) }
        end

        context 'test-app with custom log level' do
          let(:params) { { dir: '/srv/testapp', log_level: 'info' } }

          it { is_expected.to contain_file('/etc/gunicorn.d/test-app').with_mode('0644').with_content(%r{--log-level=info}) }
        end

        context 'test-app with custom gunicorn preload arguments' do
          let(:params) { { dir: '/srv/testapp', args: ['--preload'] } }

          it { is_expected.to contain_file('/etc/gunicorn.d/test-app').with_mode('0644').with_content(%r{--preload}) }
        end

        context 'test-app with custom workers count' do
          let(:params) { { dir: '/srv/testapp', workers: 42 } }

          it { is_expected.to contain_file('/etc/gunicorn.d/test-app').with_mode('0644').with_content(%r{--workers=#{params[:workers]}}) }
        end
      end
    end
  end
end
