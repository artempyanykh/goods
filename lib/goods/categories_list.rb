module Goods
  class CategoriesList
    extend Container
    container_for Category

    def initialize(categories = [])
      categories.each do |category|
        add category
      end
    end
  end
end
