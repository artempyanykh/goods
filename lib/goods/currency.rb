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

    def valid?
      reset_validation

      validate :id, proc { |val| !(val.nil? || val.empty?) }
      validate :rate, proc { |val| val >= 1 }
      validate :plus, proc { |val| val >= 0 }

      invalid_fields.empty?
    end

    def in(other_currency)
      self.rate/other_currency.rate
    end
  end
end
