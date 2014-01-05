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

  describe "#add" do
    context "when hash is passed" do
      it "should at first create an object" do
        expect(Goods::Currency).to receive(:new) { double :valid? => true }
        subject.add({})
      end
    end

    context "when object is passed" do
      let(:a_double) do
        instance_double(Goods::Currency, :kind_of? => true, :valid? => true)
      end

      it "should not create new currency" do
        expect(Goods::Currency).to_not receive(:new)
        subject.add a_double
      end

      it "should add to list valid currencies" do
        expect { subject.add(a_double) }.to change(subject, :size).by(1)
      end

      it "should remember invalid currencies" do
        allow(a_double).to receive(:valid?).and_return(false)
        expect { subject.add(a_double) }.to change(subject.defectives, :size).by(1)
      end
    end
  end
end
