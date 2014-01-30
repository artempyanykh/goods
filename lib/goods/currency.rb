module Goods
  class Currency < Element
    attr_field :rate, :plus, type: :float

    def in(other_currency)
      self.rate/other_currency.rate
    end

    private

    def apply_validation_rules
      validate :id, proc { |val| !(val.nil? || val.empty?) }
      validate :rate, proc { |val| val >= 1 }
      validate :plus, proc { |val| val >= 0 }
    end
  end
end
