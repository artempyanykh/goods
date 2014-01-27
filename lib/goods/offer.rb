module Goods
  class Offer
    include Containable
    attr_accessor :category, :currency, :price
    attr_field :category_id
    attr_field :currency_id
    attr_field :available
    attr_field :description
    attr_field :model
    attr_field :name
    attr_field :picture
    attr_field :vendor

    def initialize(description)
      self.description = description
      @price = description[:price].to_f
    end

    def convert_currency(other_currency)
      self.price *= currency.in(other_currency)
      self.currency = other_currency
      @currency_id = other_currency.id
    end

    def change_category(other_category)
      self.category = other_category
      @category_id = other_category.id
    end

    private

    def apply_validation_rules
      validate :id, proc { |val| !(val.nil? || val.empty?) }
      validate :category_id, proc { |category_id|
        category_id && category && (category_id == category.id)
      }
      validate :currency_id, proc { |currency_id|
        currency_id && currency && (currency_id == currency.id)
      }
      validate :price, proc { |price| price && price > 0 }
    end
  end
end
