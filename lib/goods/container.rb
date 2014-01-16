module Goods
  module Container
    def container_for(klass)
      define_singleton_method :_containable_class do
        klass
      end

      include ContainerMethods
      include Enumerable
      # Need to redefine Enumerable#find
      include SearchMethods
    end

    module ContainerMethods
      def add(object_or_hash)
        element = prepare(object_or_hash)

        if element.valid?
          items[element.id] = element
        else
          defectives << element
        end
      end

      def defectives
        @defectives ||= []
      end

      def each(&block)
        items.values.each(&block)
      end

      def size
        items.size
      end

      private

      def items
        @items ||= {}
      end

      def prepare(object_or_hash)
        if object_or_hash.kind_of? self.class._containable_class
          object_or_hash
        else
          self.class._containable_class.new(object_or_hash)
        end
      end
    end

    module SearchMethods
      def find(id)
        items[id]
      end
    end
  end
end
