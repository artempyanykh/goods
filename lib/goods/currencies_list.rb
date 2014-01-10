module Goods
  class CurrenciesList
    extend Container
    container_for Currency

    def initialize(currencies = [])
      currencies.each do |currency|
        add currency
      end
    end
  end
end
