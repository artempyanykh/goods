require 'open-uri'

module Goods
  class Catalog
    attr_reader :categories, :currencies, :offers

    def initialize(params)
      if params[:string]
        from_string(params[:string], params[:url], params[:encoding])
      elsif params[:url]
        from_url(params[:url], params[:encoding])
      elsif params[:file]
        from_file(params[:file], params[:encoding])
      else
        raise ArgumentError, "should provide either :string or :url param"
      end
    end

    private

    def from_string(xml_string, url, encoding)
      @xml_string = xml_string
      @xml = XML.new(xml_string, url, encoding)
      @categories = CategoriesList.new(@xml.categories)
      @currencies = CurrenciesList.new(@xml.currencies)
      @offers = OffersList.new(@categories, @currencies, @xml.offers)
    end

    def from_url(url, encoding)
      xml_string = self.load url
      from_string(xml_string, url, encoding)
    end

    def from_file(file, encoding)
      xml_string = self.load file
      from_string(xml_string, nil, xml_encoding)
    end

    def load(source)
      open(source) do |f|
        f.read
      end
    end
  end
end
