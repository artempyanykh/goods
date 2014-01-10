module Goods
  class Currency
    def initialize(list, description)
      @list = list
      @description = description
    end

    attr_reader :list

    def id
      @id ||= @description[:id]
    end

    def rate
      @rate ||= @description[:rate]
    end

    def plus
      @plus ||= @description[:plus]
    end

    def invalid_fields
      @invalid_field ||= []
    end

    def valid?
      reset_validation

      validate :list, proc { |val| !val.nil? }
      validate :id, proc { |val| !(val.nil? || val.empty?) }
      validate :rate, proc { |val| val >= 1 }
      validate :plus, proc { |val| val >= 0 }

      invalid_fields.empty?
    end

    private

    def reset_validation
      invalid_fields.clear
    end

    def validate(field, predicate)
       invalid_fields << field unless predicate.call(send(field))
    end

  end
end
