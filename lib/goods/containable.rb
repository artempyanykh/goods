module Goods
  module Containable
    def description
      @description
    end

    def id
      @id ||= description[:id]
    end

    def invalid_fields
      @invalid_fields ||= []
    end

    private

    def reset_validation
      invalid_fields.clear
    end

    def validate(field, predicate)
       invalid_fields << field unless predicate.call(send(field))
    end

    def description=(description)
      @description = description
    end
  end
end
