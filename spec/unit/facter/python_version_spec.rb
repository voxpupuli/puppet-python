require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  let(:python_version_output) { <<-EOS
Python 2.7.9
EOS
  }

  describe "python_version" do
    context 'returns python version when python present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with("python").returns(true)
        Facter::Util::Resolution.expects(:exec).with("python -V 2>&1").returns(python_version_output)
        Facter.value(:python_version).should == "2.7.9"
      end
    end

    context 'returns nil when python not present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with("python").returns(false)
        Facter.value(:python_version).should == nil
      end
    end

  end
end
