module Goods
  class Category
    include Containable
    attr_accessor :parent
    attr_field :parent_id
    attr_field :name

    def initialize(info_hash)
      self._info_hash = info_hash
      @parent_at_level = {}
    end

    def level
      @level ||=
        begin
          if parent
            parent.level + 1
          else
            0
          end
        end
    end

    def root
      return self unless parent
      @root ||= parent.root
    end

    def parent_at_level(level)
      valid_parent_level?(level) or raise ArgumentError.new('incorrect level')
      return self if self.level == level

      @parent_at_level[level] ||= parent.parent_at_level(level)
    end

    private

    def valid_parent_level?(level)
      level >= 0 && level <= self.level
    end

    def apply_validation_rules
      validate :id, proc { |val| !(val.nil? || val.empty?) }
      validate :name, proc { |val| !(val.nil? || val.empty?) }
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
