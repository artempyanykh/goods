require 'spec_helper'

describe Goods do
  it 'should have a version number' do
    expect(Goods::VERSION).to_not be_nil
  end
end
