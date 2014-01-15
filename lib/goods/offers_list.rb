module Goods
  class OffersList
    extend Container
    container_for Offer
    attr_accessor :categories_list, :currencies_list

    def initialize(categories_list = nil, currencies_list = nil, offers = [])
      self.categories_list = categories_list
      self.currencies_list = currencies_list
      offers.each do |offer|
        add offer
      end
    end

    private

    def prepare(object_or_hash)
      object = super
      object.category = categories_list.find(object.category_id) if categories_list
      object.currency = currencies_list.find(object.currency_id) if currencies_list
      object
    end
  end
end
