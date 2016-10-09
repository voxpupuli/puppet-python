require 'spec_helper'

describe 'python', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { is_expected.to contain_class("python::install") }
      # Base debian packages.
      it { is_expected.to contain_package("python") }
      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package("python-dev").with_alias("python-dev") }
      when 'RedHat', 'Suse'
        it { is_expected.to contain_package("python-dev").with_name("python-devel") }
        it { is_expected.to contain_package("python-dev").with_alias("python-devel") }
      end

      it { is_expected.to contain_package("pip") }
      # Basic python packages (from pip)
      it { is_expected.to contain_package("virtualenv")}

      describe "with python::dev" do
        context "true" do
          let (:params) {{ :dev => 'present' }}
          it { is_expected.to contain_package("python-dev").with_ensure('present') }
        end
        context "empty/default" do
          it { is_expected.to contain_package("python-dev").with_ensure('absent') }
        end
      end

      describe "with manage_gunicorn" do
        context "true" do
          let (:params) {{ :manage_gunicorn => true }}
          it { is_expected.to contain_package("gunicorn") }
        end
        context "empty args" do
          #let (:params) {{ :manage_gunicorn => '' }}
          it { is_expected.to contain_package("gunicorn") }
        end
        context "false" do
          let (:params) {{ :manage_gunicorn => false }}
          it {is_expected.not_to contain_package("gunicorn")}
        end
      end

      describe "with python::provider" do
        context "pip" do
          let (:params) {{ :provider => 'pip' }}
          it { is_expected.to contain_package("virtualenv").with(
            'provider' => 'pip'
          )}
          it { is_expected.to contain_package("pip").with(
            'provider' => 'pip'
          )}
        end

        # python::provider
        context "default" do
          let (:params) {{ :provider => '' }}
          it { is_expected.to contain_package("virtualenv")}
          it { is_expected.to contain_package("pip")}

          describe "with python::virtualenv" do
            context "true" do
              case facts[:osfamily]
              when 'Debian'
                let (:params) {{ :provider => '', :virtualenv => true }}
              when 'RedHat', 'Suse'
                let (:params) {{ :provider => '', :virtualenv => 'present' }}
              end
              it { is_expected.to contain_package("virtualenv").with_ensure('present') }
            end
          end

          case facts[:osfamily]
          when 'Debian'
            describe "without python::virtualenv" do
              context "default/empty" do
                let (:params) {{ :provider => '' }}
                it { is_expected.to contain_package("virtualenv").with_ensure('absent') }
              end
            end
          when 'RedHat', 'Suse'
            describe "with python::virtualenv" do
              context "default/empty" do
                let (:params) {{ :provider => '' }}
                it { is_expected.to contain_package("virtualenv").with_ensure('absent') }
              end
            end
          end
        end
      end
    end
  end
end
