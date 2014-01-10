module Goods
  module Container
    def container_for(klass)
      define_singleton_method :_contents_class do
        klass
      end

      include InstanceMethods
    end
  end

  module InstanceMethods
    def add(object_or_hash)
      element = prepare(object_or_hash)

      if element.valid?
        items[element.id] = element
      else
        defectives << element
      end
    end

    def find(id)
      items[id] 
    end

    def each
      items.values.each
    end

    def defectives
      @defectives ||= []
    end

    def size
      items.size
    end

    private

    def items
      @items ||= {}
    end

    def prepare(object_or_hash)
      if object_or_hash.kind_of? self.class._contents_class
        object_or_hash
      else
        self.class._contents_class.new(self, object_or_hash)
      end
    end
  end
end
