require "spec_helper"

describe Goods::Category do
  let(:valid_description) { {id: "1", name: "Name"} }

  it_should_behave_like "containable" do
    let(:element) { Goods::Category.new(valid_description) }
  end

  describe "#valid?" do
    let(:parent) { Goods::Category.new(id: "1", name: "Parent") }

    it "should reject categories with no parent when one should be" do
      invalid_child = Goods::Category.new(id: "3", name: "Invalid child", parent_id: "2")
      expect(invalid_child).not_to be_valid
    end

    it "should reject categories with incorrect parrent" do
      invalid_child = Goods::Category.new(id: "3", name: "Invalid child", parent_id: "2")
      invalid_child.parent = parent
      expect(invalid_child).not_to be_valid
    end

    it "should accept categories with no parent" do
      child = Goods::Category.new(valid_description)
      child.valid?
      puts child.invalid_fields
      expect(child).to be_valid
    end

    it "should accept categories with correct parent" do
      valid_child = Goods::Category.new(id: "3", name: "Invalid child", parent_id: "1")
      valid_child.parent = parent
      expect(valid_child).to be_valid
    end
  end
end
