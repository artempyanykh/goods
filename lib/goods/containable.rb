module Goods
  module Containable
    def self.included(base)
      # Class macro that defined mathod to access instance variable @field_name
      # in the following way (illustrative example)
      #
      # def field_name
      #   @field_name ||= description[field_name]
      # end
      base.define_singleton_method :attr_field do |field_name|
        define_method field_name do
          if field = instance_variable_get("@#{field_name}")
            field
          else
            instance_variable_set("@#{field_name}", description[field_name])
            instance_variable_get("@#{field_name}")
          end
        end
      end
    end

    def description
      @description
    end

    def id
      @id ||= description[:id]
    end

    def invalid_fields
      @invalid_fields ||= []
    end

    def valid?
      reset_validation
      apply_validation_rules
      invalid_fields.empty?
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
