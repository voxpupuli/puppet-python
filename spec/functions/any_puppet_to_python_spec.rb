require 'spec_helper'

describe 'any_puppet_to_python' do
  context 'with Array[Any]' do
    it { is_expected.to run.with_params([]).and_return('[]') }
    it { is_expected.to run.with_params([[[[], 1], '2'], 3]).and_return('[[[[], 1], "2"], 3]') }
    it { is_expected.to run.with_params([42, 'foo', true, {}]).and_return('[42, "foo", True, {}]') }
  end
  context 'with Hash[Any]' do
    it { is_expected.to run.with_params({}).and_return('{}') }
    it { is_expected.to run.with_params({ '1' => { 2 => { '3' => {} } } }).and_return('{"1": {2: {"3": {}}}}') }
    it { is_expected.to run.with_params({ 42 => 42, 'foo' => 'bar', '6 * 9' => { 'answer' => [42] } }).and_return('{42: 42, "foo": "bar", "6 * 9": {"answer": [42]}}') }
  end
  context 'with Boolean' do
    it { is_expected.to run.with_params(true).and_return('True') }
    it { is_expected.to run.with_params(false).and_return('False') }
  end
  context 'with String' do
    it { is_expected.to run.with_params('').and_return('""') }
    it { is_expected.to run.with_params('foo').and_return('"foo"') }
    it { is_expected.to run.with_params("foo\nbar").and_return('"foo\nbar"') }
  end
  context 'with Undef' do
    it { is_expected.to run.with_params(:undef).and_return('None') }
  end
end
