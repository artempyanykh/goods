module Goods
  class XML
    def initialize(string, url = nil, encoding = nil)
      @xml_source = Nokogiri::XML::Document.parse(string, url, encoding)
    end

    def categories
      @categories ||= extract_categories
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
  end
end
