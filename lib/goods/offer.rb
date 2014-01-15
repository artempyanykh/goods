module Goods
  class Offer
    include Containable
    attr_accessor :category, :currency
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
    end

    def price
      @price ||= description[:price].to_f
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
