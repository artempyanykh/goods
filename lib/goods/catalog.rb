module Goods
  class Catalog
    attr_reader :categories, :currencies, :offers

    def initialize(params)
      if params[:io]
        from_io(params[:io], params[:url], params[:encoding])
      else
        raise ArgumentError, "should provide either :string or :url param"
      end
    end

    def prune(level)
      @offers.prune_categories(level)
      @categories.prune(level)
    end

    def convert_currency(other_currency)
      @offers.convert_currency(other_currency)
    end

    def date
      @xml.generation_date
    end

    private

    def from_io(xml_io, url, encoding)
      @xml = XML.new(xml_io, url, encoding)
      @categories = CategoriesList.new(@xml.categories)
      @currencies = CurrenciesList.new(@xml.currencies)
      @offers = OffersList.new(@categories, @currencies, @xml.offers)
    end
  end
end