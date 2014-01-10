module Goods
  class Currency
    include Containable

    def initialize(list, description)
      self.list = list
      self.description = description
    end

    def rate
      @rate ||= description[:rate]
    end

    def plus
      @plus ||= description[:plus]
    end

    def valid?
      reset_validation

      validate :list, proc { |val| !val.nil? }
      validate :id, proc { |val| !(val.nil? || val.empty?) }
      validate :rate, proc { |val| val >= 1 }
      validate :plus, proc { |val| val >= 0 }

      invalid_fields.empty?
    end
  end
end
