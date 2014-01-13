module Goods
  class Currency
    include Containable

    def initialize(description)
      self.description = description
    end

    def rate
      @rate ||= description[:rate].to_f
    end

    def plus
      @plus ||= description[:plus].to_f
    end

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
