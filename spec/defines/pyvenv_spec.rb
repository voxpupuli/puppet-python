require 'spec_helper'

describe 'python::pyvenv', :type => :define do
  let (:title) { '/opt/env' }

  it {
    should contain_file( '/opt/env')
    should contain_exec( "python_virtualenv_/opt/env").with_command("pyvenv  /opt/env")
  }

  describe 'when ensure' do
    context "is absent" do
      let (:params) {{
        :ensure => 'absent'
      }}
      it {
        should contain_file( '/opt/env').with_ensure('absent').with_purge( true)
      }
    end
  end
end
