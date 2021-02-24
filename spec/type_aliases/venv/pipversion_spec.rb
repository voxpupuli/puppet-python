require 'spec_helper'

describe 'Python::Venv::PipVersion' do
  describe 'valid values' do
    [
      '< 1',
      '< 0.1',
      '< 1.2.3',
      '< 1.2.3.40',
      '<= 1',
      '<= 0.1',
      '<= 1.2.3',
      '<= 1.2.3.40',
      '> 1',
      '> 0.1',
      '> 1.2.3',
      '> 1.2.3.40',
      '>= 1',
      '>= 0.1',
      '>= 1.2.3',
      '>= 1.2.3.40',
      '== 1',
      '== 0.1',
      '== 1.2.3',
      '== 1.2.3.40',
    ].each do |value|
      describe value.inspect do
        it {
          is_expected.to allow_value(value)
        }
      end
    end
  end

  describe 'invalid values' do
    [
      '+ 1',
      '- 0.1',
      '< -1',
      '< 1.+2.3.40',
      '<=',
      '<= 0.-1',
      '<= 1.f.3',
      '1.2.3.0',
      'pip > 1',
      'all',
      -1,
      65_536,
      :undef,
    ].each do |value|
      describe value.inspect do
        it {
          is_expected.not_to allow_value(value)
        }
      end
    end
  end
end
