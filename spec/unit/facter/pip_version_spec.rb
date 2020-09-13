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

  let(:pip2_version_output) do
    <<-EOS
pip 9.0.1 from /usr/lib/python2.7/dist-packages/pip (python 2.7)
EOS
  end

  let(:pip3_version_output) do
    <<-EOS
pip 18.1 from /usr/lib/python3/dist-packages/pip (python 3.7)
EOS
  end

  describe 'pip_version' do
    context 'returns pip version when pip present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('pip').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('pip --version 2>&1').and_return(pip_version_output)
        expect(Facter.value(:pip_version)).to eq('6.0.6')
      end
    end

    context 'returns nil when pip not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('pip').and_return(false)
        expect(Facter.value(:pip_version)).to eq(nil)
      end
    end
  end

  describe 'pip2_version' do
    context 'returns pip2 version when pip2 present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('pip2').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('pip2 --version 2>&1').and_return(pip2_version_output)
        expect(Facter.value(:pip2_version)).to eq('9.0.1')
      end
    end

    context 'returns nil when pip2 not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('pip2').and_return(false)
        expect(Facter.value(:pip2_version)).to eq(nil)
      end
    end
  end

  describe 'pip3_version' do
    context 'returns pip3 version when pip3 present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('pip3').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('pip3 --version 2>&1').and_return(pip3_version_output)
        expect(Facter.value(:pip3_version)).to eq('18.1')
      end
    end

    context 'returns nil when pip3 not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('pip3').and_return(false)
        expect(Facter.value(:pip3_version)).to eq(nil)
      end
    end
  end
end
