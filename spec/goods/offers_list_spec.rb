require 'spec_helper'

describe Goods::OffersList do
  let(:categories_list) { Goods::CategoriesList.new([{id: "1", name: "Category"}]) }
  let(:currencies_list) { Goods::CurrenciesList.new([{id: "RUR", rate: 1, plus: 0}]) }
  let(:offers_list) { Goods::OffersList.new(categories_list, currencies_list) }
  let(:subject) { offers_list }

  it_should_behave_like "a container",
    Goods::Offer,
    Goods::Offer.new(id: "1", url: "url.com", category_id: "1", currency_id: "RUR", price: 10) do
      let(:subject) { offers_list }
    end

  describe "#add" do
    it "should setup category and currency for offer" do
      offer = Goods::Offer.new(id: "1", url: "url.com", category_id: "1", currency_id: "RUR", price: 10)
      subject.add(offer)

      expect(offer.category).to be(categories_list.find("1"))
      expect(offer.currency).to be(currencies_list.find("RUR"))
    end
  end
end
