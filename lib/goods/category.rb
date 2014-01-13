module Goods
  class Category
    include Containable
    attr_accessor :parent
    attr_field :parent_id
    attr_field :name

    def initialize(description)
      self.description = description
    end

    private

    def apply_validation_rules
      validate :id, proc { |val| !(val.nil? || val.empty?) }
      # validate :name, proc { |val| !(val.nil? || val.empty?) }
      validate :parent_id, proc { |parent_id|
        if !(parent_id.nil? || parent_id.empty?)
          parent && (parent.id == parent_id)
        else
          parent == nil
        end
      }
    end
  end
end
