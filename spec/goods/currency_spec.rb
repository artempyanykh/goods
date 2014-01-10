require 'spec_helper'

describe Goods::Currency do
  let(:list) { Goods::CurrenciesList.new }
  let(:valid_description) { {id: "VAL_CUR", rate: 1, plus: 0} }
  let(:valid_currency) { Goods::Currency.new(list, valid_description) }

  it_should_behave_like "containable" do
    let(:element) { valid_currency }
  end

  describe "#valid?" do
    let(:invalid_description) { {id: "", rate: 0, plus: -1} }

    it "should return true for valid currency" do
      expect(Goods::Currency.new(list, valid_description).valid?).to be true
    end

    it "should return false for invalid currency" do
      expect(Goods::Currency.new(nil, invalid_description).valid?).to be false
    end

    it "should remember invalid fields" do
      invalid_currency = Goods::Currency.new(nil, invalid_description)
      invalid_currency.valid?
      [:list, :id, :rate, :plus].each do |field|
        expect(invalid_currency.invalid_fields).to include(field)
      end
    end
  end
end
