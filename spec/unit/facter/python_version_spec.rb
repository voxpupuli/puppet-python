require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  let(:python2_version_output) do
    <<-EOS
Python 2.7.9
EOS
  end
  let(:python3_version_output) do
    <<-EOS
Python 3.3.0
EOS
  end

  describe 'python_version' do
    context 'returns Python version when `python` present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python2_version_output)
        expect(Facter.value(:python_version)).to eq('2.7.9')
      end
    end

    context 'returns nil when `python` not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(false)
        expect(Facter.value(:python_version)).to eq(nil)
      end
    end
  end

  describe 'python2_version' do
    context 'returns Python 2 version when `python` is present and Python 2' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python2_version_output)
        expect(Facter.value(:python2_version)).to eq('2.7.9')
      end
    end

    context 'returns Python 2 version when `python` is Python 3 and `python2` is present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python3_version_output)
        allow(Facter::Util::Resolution).to receive(:which).with('python2').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python2 -V 2>&1').and_return(python2_version_output)
        expect(Facter.value(:python2_version)).to eq('2.7.9')
      end
    end

    context 'returns nil when `python` is Python 3 and `python2` is absent' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python3_version_output)
        allow(Facter::Util::Resolution).to receive(:which).with('python2').and_return(false)
        expect(Facter.value(:python2_version)).to eq(nil)
      end
    end

    context 'returns nil when `python2` and `python` are absent' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python2').and_return(false)
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(false)
        expect(Facter.value(:python2_version)).to eq(nil)
      end
    end
  end

  describe 'python3_version' do
    context 'returns Python 3 version when `python3` present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python3').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python3 -V 2>&1').and_return(python3_version_output)
        expect(Facter.value(:python3_version)).to eq('3.3.0')
      end
    end

    context 'returns nil when `python3` not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python3').and_return(false)
        expect(Facter.value(:python3_version)).to eq(nil)
      end
    end
  end
end
