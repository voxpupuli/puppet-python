require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  let(:pip_version_output) do
    <<-EOS
pip 6.0.6 from /opt/boxen/homebrew/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/pip-6.0.6-py2.7.egg (python 2.7)
EOS
  end

  describe 'pip_version' do
    context 'returns pip version when pip present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with('pip').returns(true)
        Facter::Util::Resolution.expects(:exec).with('pip --version 2>&1').returns(pip_version_output)
        expect(Facter.value(:pip_version)).to eq('6.0.6')
      end
    end

    context 'returns nil when pip not present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with('pip').returns(false)
        expect(Facter.value(:pip_version)).to eq(nil)
      end
    end
  end
end
