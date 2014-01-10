require 'spec_helper'

describe Goods::CurrenciesList do
  describe "#initialize" do
    it "should instantiate an empty list when no currency provided" do
      expect(subject.size).to eq(0)
    end

    it "should use #add for adding new items" do
      expect_any_instance_of(Goods::CurrenciesList).to receive(:add).
        with({}).exactly(2).times
      Goods::CurrenciesList.new([{}, {}])
    end
  end

  it_should_behave_like "a container", Goods::Currency
end
