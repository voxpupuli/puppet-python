require 'spec_helper'

describe 'python::pip', :type => :define do
  let (:title) { 'rpyc' }
  context "on Debian OS" do
    let :facts do
      {
        :id                     => 'root',
        :kernel                 => 'Linux',
        :lsbdistcodename        => 'squeeze',
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '6',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :concat_basedir         => '/dne',
      }
    end

    describe "virtualenv as" do
      context "fails with non qualified path" do
        let (:params) {{ :virtualenv => "venv" }}
        it { is_expected.to raise_error(/"venv" is not an absolute path./) }
      end
      context "suceeds with qualified path" do
        let (:params) {{ :virtualenv => "/opt/venv" }}
        it { is_expected.to contain_exec("pip_install_rpyc").with_cwd('/opt/venv') }
      end
      context "defaults to system" do
        let (:params) {{ }}
        it { is_expected.to contain_exec("pip_install_rpyc").with_cwd('/') }
      end
    end
  end
end