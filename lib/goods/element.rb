module Goods
  class Element

    def self.generate_accessor(field_name, type)
      define_method field_name do
        if field = instance_variable_get("@#{field_name}")
          field
        else
          setup_instance_variable(field_name, type)
          instance_variable_get("@#{field_name}")
        end
      end
    end

    # Class macro that defined mathods to access instance variables @some_field
    # in the following way (illustrative example)
    #
    # attr_field :field_name
    #
    # is equivalent to
    #
    # def field_name
    #   @field_name ||= description[:field_name]
    # end
    #
    # This method can take several arguments with optional hash at the end.
    # Semantics is the same as with attr_* family of methods.
    #
    # You can specify the type of field by providin {type: :some_type} hash as
    # the last argument. For example type: :float will call #to_f on resulting
    # value.
    def self.attr_field(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      type = opts[:type] || :string

      args.each do |field_name|
        self.generate_accessor(field_name, type)
      end
    end

    def initialize(info_hash)
      @info_hash = info_hash
    end

    attr_field :id

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

    def setup_instance_variable(name, type)
      case type
      when :string
        instance_variable_set("@#{name}", @info_hash[name])
      when :float
        instance_variable_set("@#{name}", @info_hash[name].to_f)
      else
        raise ArgumentError, 'wrong type'
      end
    end
  end
end
