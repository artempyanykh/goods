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

  describe "#prune_categories" do
    let(:categories) do
      list = Goods::CategoriesList.new [
        {id: "1", name: "root"},
        {id: "11", name: "root", parent_id: "1"},
        {id: "12", name: "root", parent_id: "11"}
      ]
      list
    end
    let(:offers) do
      list = Goods::OffersList.new categories, currencies_list, [
        {id: "1", category_id: "1", currency_id: "RUR", price: 1},
        {id: "2", category_id: "11", currency_id: "RUR", price: 1},
        {id: "3", category_id: "12", currency_id: "RUR", price: 1}
      ]
      list
    end

    it "should raise error if level < 0" do
      expect{ offers.prune_categories }.to raise_error(ArgumentError)
    end

    it "should replace deep categories with their parents on specified level" do
      offers.prune_categories(1)
      expect(offers.find("3").category).to be(categories.find("11"))
    end

    it "should not affect offers with categories having lower level" do
      offers.prune_categories(1)
      expect(offers.find("1").category).to be(categories.find("1"))
    end
  end
end
