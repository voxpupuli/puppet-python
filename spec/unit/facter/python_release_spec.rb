# frozen_string_literal: true

require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  # rubocop:disable RSpec/IndexedLet
  let(:python2_version_output) do
    <<~EOS
      Python 2.7.9
    EOS
  end
  let(:python3_version_output) do
    <<~EOS
      Python 3.3.0
    EOS
  end
  # rubocop:enable RSpec/IndexedLet

  describe 'python_release' do
    context 'returns Python release when `python` present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python2_version_output)
        expect(Facter.value(:python_release)).to eq('2.7')
      end
    end

    context 'returns nil when `python` not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:exec).and_return(false)
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(false)
        expect(Facter.value(:python_release)).to be_nil
      end
    end
  end

  describe 'python2_release' do
    context 'returns Python 2 release when `python` is present and Python 2' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python2_version_output)
        expect(Facter.value(:python2_release)).to eq('2.7')
      end
    end

    context 'returns Python 2 release when `python` is Python 3 and `python2` is present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python3_version_output)
        allow(Facter::Util::Resolution).to receive(:which).with('python2').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python2 -V 2>&1').and_return(python2_version_output)
        expect(Facter.value(:python2_release)).to eq('2.7')
      end
    end

    context 'returns nil when `python` is Python 3 and `python2` is absent' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python -V 2>&1').and_return(python3_version_output)
        allow(Facter::Util::Resolution).to receive(:which).with('python2').and_return(false)
        expect(Facter.value(:python2_release)).to be_nil
      end
    end

    context 'returns nil when `python2` and `python` are absent' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python').and_return(false)
        allow(Facter::Util::Resolution).to receive(:which).with('python2').and_return(false)
        expect(Facter.value(:python2_release)).to be_nil
      end
    end
  end

  describe 'python3_release' do
    context 'returns Python 3 release when `python3` present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python3').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('python3 -V 2>&1').and_return(python3_version_output)
        expect(Facter.value(:python3_release)).to eq('3.3')
      end
    end

    context 'returns nil when `python3` not present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('python3').and_return(false)
        expect(Facter.value(:python3_release)).to be_nil
      end
    end
  end
end
