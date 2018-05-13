require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  let(:virtualenv_version_output) do
    <<-EOS
12.0.7
EOS
  end

  describe 'virtualenv_version' do
    context 'returns virtualenv version when virtualenv present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with('virtualenv').returns(true)
        Facter::Util::Resolution.expects(:exec).with('virtualenv --version 2>&1').returns(virtualenv_version_output)
        expect(Facter.value(:virtualenv_version)).to eq('12.0.7')
      end
    end

    context 'returns nil when virtualenv not present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with('virtualenv').returns(false)
        expect(Facter.value(:virtualenv_version)).to eq(nil)
      end
    end
  end
end
