module Goods
  class Currency
    include Containable

    def initialize(info_hash)
      self._info_hash = info_hash
    end

    def rate
      @rate ||= _info_hash[:rate].to_f
    end

    def plus
      @plus ||= _info_hash[:plus].to_f
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
