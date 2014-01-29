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
            instance_variable_set("@#{field_name}", _info_hash[field_name])
            instance_variable_get("@#{field_name}")
          end
        end
      end
    end

    def _info_hash
      @_info_hash
    end
    private :_info_hash

    def id
      @id ||= _info_hash[:id]
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

    def _info_hash=(info_hash)
      @_info_hash = info_hash
    end
    private :_info_hash=
  end
end
