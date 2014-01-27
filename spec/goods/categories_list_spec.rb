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

  describe "#prune" do
    let(:list) do
      list = Goods::CategoriesList.new [
        {id: "1", name: "root"},
        {id: "11", name: "root", parent_id: "1"},
        {id: "12", name: "root", parent_id: "2"}
      ]
      list
    end

    it "should raise error if prune level < 0" do
      expect{ list.prune(-1) }.to raise_error(ArgumentError)
    end

    it "should not make any changes to nodes with level lesser than target level" do
      orig = list.dup
      list.prune(3)
      expect(list.size).to eq(orig.size)
    end

    it "should remove nodes with level greater than target level" do
      list.prune(1)
      expect(list.size).to eq(2)
      list.each { |item| expect(item.level < 2).to eql(true) }
    end
  end
end
