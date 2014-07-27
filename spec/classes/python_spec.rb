require_relative '../../spec_helper'

describe 'python', :type => :class do
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

    it { is_expected.to contain_class("python::install") }
    # Base debian packages.
    it { is_expected.to contain_package("python") }
    it { is_expected.to contain_package("python-dev") }
    it { is_expected.to contain_package("python-pip") }
    # Basic python packages (from pip)
    it { is_expected.to contain_package("python-virtualenv")}
    
    describe "with manage_gunicorn" do
      context "true" do
        let (:params) {{ :manage_gunicorn => true }} 
        it { is_expected.to contain_package("gunicorn") }
      end
    end
    describe "with manage_gunicorn" do
      context "empty args" do
        #let (:params) {{ :manage_gunicorn => '' }} 
        it { is_expected.to contain_package("gunicorn") }
      end
    end
    
    describe "without mange_gunicorn" do
      context "false" do
        let (:params) {{ :manage_gunicorn => false }} 
        it {is_expected.not_to contain_package("gunicorn")}
      end
    end

  end
  
  context "on a Redhat 5 OS" do
    let :facts do
      {
        :id => 'root',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '5',
        :concat_basedir => '/dne',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    it { is_expected.to contain_class("python::install") }
    # Base debian packages.
    it { is_expected.to contain_package("python") }
    it { is_expected.to contain_package("python-devel") }
    it { is_expected.to contain_package("python-pip") }
    # Basic python packages (from pip)
    it { is_expected.to contain_package("python-virtualenv")}

  end

end
