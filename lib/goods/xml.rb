require "nokogiri"

module Goods
  class XML
    class InvalidFormatError < StandardError; end

    def initialize(io, url = nil, encoding = nil)
      @xml_source = Nokogiri::XML::Document.parse(io, url, encoding)
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

    def generation_date
      @generation_date ||= extract_catalog_generation_date
    end


    private


    def catalog_node
      @xml_source / "yml_catalog"
    end

    def shop_node
      catalog_node / "shop"
    end

    def extract_catalog_generation_date
      Time.parse(catalog_node.attribute("date").value)
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
        id: extract_attribute(category, :id),
        name: extract_text(category)
      }
      category_hash[:parent_id] = extract_attribute(category, "parentId")

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
        id: extract_attribute(currency, "id")
      }

      attributes_with_defaults = {
        rate: "1",
        plus: "0"
      }
      attributes_with_defaults.each do |attr, default|
        currency_hash[attr] = extract_attribute(currency, attr, default)
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
        id: extract_attribute(offer, "id")
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
      }.each do |property, xpath|
        offer_hash[property] = extract_text(offer, xpath)
      end

      offer_hash[:price] = extract_text(offer, "price").to_f

      offer_hash
    end

    def extract_attribute(node, attribute, default = nil)
      if node.attribute(attribute.to_s)
        node.attribute(attribute.to_s).value.strip
      else
        default
      end
    end

    def extract_text(node, xpath = nil, default = nil)
      target = if xpath
        node.xpath(xpath).first
      else
        node
      end

      if target
        target.text.strip
      else
        default
      end
    end
  end
end
