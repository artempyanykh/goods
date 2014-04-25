require 'spec_helper'

describe Goods::OffersList do
  let(:categories) { Goods::CategoriesList.new([{id: "1", name: "Category"}]) }
  let(:currencies) { Goods::CurrenciesList.new([{id: "RUR", rate: 1, plus: 0}]) }
  let(:offers) { Goods::OffersList.new(categories, currencies) }
  let(:subject) { offers }

  it_should_behave_like "a container",
    Goods::Offer,
    Goods::Offer.new(id: "1", url: "url.com", category_id: "1", currency_id: "RUR", price: 10) do
      let(:subject) { offers }
    end

  describe "#add" do
    let (:urls) {['url1', 'url2', 'url3']}
    let (:offer) {Goods::Offer.new(id: "1", url: "url.com", category_id: "1", currency_id: "RUR", price: 10, pictures: urls)}

    it "should setup category and currency for offer" do
      subject.add(offer)

      expect(offer.category).to be(categories.find("1"))
      expect(offer.currency).to be(currencies.find("RUR"))
    end

    it "should setup pictures array for offer" do
      expect(offer.pictures).to be_an(Array)
      expect(offer.pictures).to contain_exactly(*urls)
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
      list = Goods::OffersList.new categories, currencies, [
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

  describe "#convert_currency" do
    let(:currencies) do
      Goods::CurrenciesList.new([
        {id: "RUR", rate: 1, plus: 0},
        {id: "USD", rate: 30, plus: 0},
        {id: "GBP", rate: 50, plus: 0}
      ])
    end
    let(:offers) do
      list = Goods::OffersList.new categories, currencies, [
        {id: "1", category_id: "1", currency_id: "USD", price: 1},
        {id: "2", category_id: "1", currency_id: "GBP", price: 1}
      ]
      list
    end

    it "should convert currency for all offers" do
      expect(offers.find("1")).to receive(:convert_currency)
      expect(offers.find("2")).to receive(:convert_currency)
      offers.convert_currency(currencies.find("RUR"))
    end
  end
end
