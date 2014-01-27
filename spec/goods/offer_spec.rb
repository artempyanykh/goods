require "spec_helper"

describe Goods::Offer do
  let(:books) { Goods::Category.new(id: "1", name: "Books") }
  let(:rur) { Goods::Currency.new(id: "RUR", rate: 1, plus: 0) }
  let(:valid_description) do
    {id: "1", name: "The Lord of The Rings", category_id: "1", currency_id: "RUR", price: 10} 
  end
  let(:valid_offer) do
    offer = Goods::Offer.new(valid_description)
    offer.category = books
    offer.currency = rur
    offer
  end

  it_should_behave_like "containable" do
    let(:element) { valid_offer }
  end

  describe "#valid?" do
    context "invalid cases" do
      let(:invalid_offer) { Goods::Offer.new({}) }

      [:id, :category_id, :currency_id, :price].each do |field|
        it "should reject offers without #{field}" do
          expect(invalid_offer).not_to be_valid
          expect(invalid_offer.invalid_fields).to include(field)
        end
      end

      it "should reject offers with non-positive price" do
        invalid_offer = Goods::Offer.new(price: -5.0)
        expect(invalid_offer).not_to be_valid
        expect(invalid_offer.invalid_fields).to include(:price)
      end
    end

    context "valid cases" do
      it "should accept offer when it has id, category, currency and price" do
        expect(valid_offer).to be_valid
      end
    end
  end

  [:available, :description, :model, :name, :picture, :vendor].each do |field|
    it "should have #{field}" do
      expect(valid_offer).to respond_to(field)
    end
  end

  it "should have floting point price" do
    expect(Goods::Offer.new(price: 5).price).to be_kind_of(Float)
  end
end
