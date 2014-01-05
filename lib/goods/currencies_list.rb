module Goods
  class CurrenciesList
    def self.find(id)

    end

    def initialize(currencies = [])
      currencies.each do |currency|
        add currency
      end
    end

    def add(currency_or_hash)
      currency = objectify(currency_or_hash)

      if currency.valid?
        items << currency
      else
        defectives << currency
      end
    end

    def items
      @items ||= []
    end

    def defectives
      @defectives ||= []
    end

    def size
      items.size
    end


    private


    def objectify(currency_or_hash)
      if currency_or_hash.kind_of? Currency
        currency_or_hash
      else
        Currency.new(self, currency_or_hash)
      end
    end
  end
end
