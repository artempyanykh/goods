require 'spec_helper'

describe Goods do
  it 'should have a version number' do
    Goods::VERSION.should_not be_nil
  end
end
