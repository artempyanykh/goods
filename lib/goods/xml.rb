require "nokogiri"

module Goods
  class XML
    class InvalidFormatError < StandardError; end

    def initialize(string, url = nil, encoding = nil)
      @xml_source = Nokogiri::XML::Document.parse(string, url, encoding)
    end

    def categories
      @categories ||= extract_categories
    end

    def currencies
      @currencies ||= extract_currencies
    end

    def offers
      @offers ||= extract_offers
    end


    private


    def catalog_node
      @xml_source / "yml_catalog"
    end

    def shop_node
      catalog_node / "shop"
    end

    # Categories part
    def categories_node
      shop_node / "categories" / "category"
    end

    def extract_categories
      categories_node.map do |category|
        category_node_to_hash(category)
      end
    end

    def category_node_to_hash(category)
      category_hash = {
        id: category.attribute("id").value,
        name: category.text
      }
      category_hash[:parent_id] = if category.attribute("parentId")
                                    category.attribute("parentId").value
                                  else
                                    nil
                                  end
      category_hash
    end

    # Currencies part
    def currencies_node
      shop_node / "currencies" / "currency"
    end

    def extract_currencies
      currencies_node.map do |currency|
        currency_node_to_hash(currency)
      end
    end

    def currency_node_to_hash(currency)
      currency_hash = {
        id: currency.attribute("id").value
      }

      attributes_with_defaults = {
        rate: "1",
        plus: "0"
      }
      attributes_with_defaults.each do |attr, default|
        currency_hash[attr] = if currency.attribute(attr.to_s)
                                currency.attribute(attr.to_s).value
                              else
                                default
                              end
      end

      currency_hash
    end

    #Offers part
    def offers_node
      shop_node / "offers" / "offer"
    end

    def extract_offers
      offers_node.map do |offer|
        offer_node_to_hash(offer)
      end
    end

    def offer_node_to_hash(offer)
      offer_hash = {
        id: offer.attribute("id").value
      }

      offer_hash[:available] = if attr = offer.attribute("available")
                                 !! (attr.value =~ /true/)
                               else
                                 true
                               end
      {
        url: "url",
        currency_id: "currencyId",
        category_id: "categoryId",
        picture: "picture",
        description: "description",
        name: "name",
        vendor: "vendor",
        model: "model"
      }.each do |property, node|
        offer_hash[property] = (el = offer.xpath(node).first) ? el.text.strip : nil
      end

      offer_hash[:price] = offer.xpath("price").first.text.to_f

      offer_hash
    end
  end
end
