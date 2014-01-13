module Goods
  class CategoriesList
    extend Container
    container_for Category

    def initialize(categories = [])
      categories.each do |category|
        add category
      end
    end

    private

    def prepare(object_or_hash)
      category = super
      category.parent = find(category.parent_id) if category.parent_id
      category
    end
  end
end
