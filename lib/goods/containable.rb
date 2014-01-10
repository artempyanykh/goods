module Goods
  module Containable
    def list
      @list
    end

    def description
      @description
    end

    def id
      @id ||= description[:id]
    end

    def rate
      @rate ||= description[:rate]
    end

    def plus
      @plus ||= description[:plus]
    end

    def invalid_fields
      @invalid_field ||= []
    end

    private

    def reset_validation
      invalid_fields.clear
    end

    def validate(field, predicate)
       invalid_fields << field unless predicate.call(send(field))
    end

    def list=(list)
      @list = list
    end

    def description=(description)
      @description = description
    end
  end
end
