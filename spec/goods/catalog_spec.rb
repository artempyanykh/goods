require 'spec_helper'

describe Goods::Catalog do
  describe "#initialize" do
    it "should call #from_string when string is passed" do
      expect_any_instance_of(Goods::Catalog).to receive(:from_string).
        with("string", "url", "UTF-8").once
      Goods::Catalog.new(string: "string", url: "url", encoding: "UTF-8")
    end

    it "should raise error when none of 'string', 'url', 'file' params is passed" do
      expect{ Goods::Catalog.new({}) }.to raise_error(ArgumentError)
    end
  end

  describe "#from_string" do
    class NullObject
      def method_missing(name, *args)
        self
      end
    end

    [Goods::XML, Goods::CategoriesList, Goods::CurrenciesList, Goods::OffersList].each do |part|
    it "should create #{part}" do
        expect(part).to receive(:new).and_return(NullObject.new).once
        Goods::Catalog.new(string: "xml")
      end
    end
  end
end
