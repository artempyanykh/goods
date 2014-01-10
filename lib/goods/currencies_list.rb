module Goods
  class CurrenciesList
    def initialize(currencies = [])
      currencies.each do |currency|
        add currency
      end
    end

    def add(object_or_hash)
      currency = objectify(object_or_hash)

      if currency.valid?
        items[currency.id] = currency
      else
        defectives << currency
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

    def objectify(object_or_hash)
      if object_or_hash.kind_of? Currency
        object_or_hash
      else
        Currency.new(self, object_or_hash)
      end
    end
  end
end
