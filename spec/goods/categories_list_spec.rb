require "spec_helper"

describe Goods::CategoriesList do
  it_should_behave_like "a container", Goods::Category, Goods::Category.new(id: "1", name: "Name")

  describe "#add" do
    it "should setup parent for category" do
      parent = Goods::Category.new(id: "1", name: "Parent")
      child = Goods::Category.new(id: "2", name: "Child", parent_id: "1")
      subject.add(parent); subject.add(child)

      expect(child.parent).to be(parent)
    end
  end
end
