require "spec_helper"

describe Goods::Category do
  let(:valid_description) { {id: "1", name: "Name"} }
  let(:root) { Goods::Category.new valid_description }

  it_should_behave_like "containable" do
    let(:element) { Goods::Category.new(valid_description) }
  end

  describe "#valid?" do
    it "should reject categories with no root when one should be" do
      invalid_child = Goods::Category.new(id: "3", name: "Invalid child", parent_id: "2")
      expect(invalid_child).not_to be_valid
    end

    it "should reject categories with incorrect parrent" do
      invalid_child = Goods::Category.new(id: "3", name: "Invalid child", parent_id: "2")
      invalid_child.parent = root
      expect(invalid_child).not_to be_valid
    end

    it "should accept categories with no root" do
      child = Goods::Category.new(valid_description)
      child.valid?
      expect(child).to be_valid
    end

    it "should accept categories with correct root" do
      valid_child = Goods::Category.new(id: "3", name: "Invalid child", parent_id: "1")
      valid_child.parent = root
      expect(valid_child).to be_valid
    end
  end

  context "on graph properties" do
    let(:first_level) do
      c = Goods::Category.new valid_description.merge parent_id: root.id
      c.parent = root
      c
    end
    let(:second_level) do
      c = Goods::Category.new valid_description.merge parent_id: first_level.id
      c.parent = first_level
      c
    end

    describe "#level" do
      it "should be 0 for root nodes" do
        expect(root.level).to eq(0)
      end

      it "should be parent level + for for child nodes" do
        expect(first_level.level).to eq(root.level + 1)
      end
    end

    describe "#root" do
      it "should be root itself if called on root" do
        expect(root.root).to be(root)
      end

      it "should be root of a branch if called on child" do
        expect(second_level.root).to be(root)
      end
    end

    describe "#parent_at_level" do

      it "should raise error if level < 0" do
        expect { root.parent_at_level(-1) }.to raise_error(ArgumentError)
      end

      it "should return self if called for object's level" do
        expect(first_level.parent_at_level(first_level.level)).to be(first_level)
      end

      it "should raise error if level > object level" do
        expect { first_level.parent_at_level first_level.level + 1 }.
          to raise_error(ArgumentError)
      end

      it "should return parent at specified level from the 'root'" do
        expect(second_level.parent_at_level(1)).to be(first_level)
        expect(second_level.parent_at_level(0)).to be(root)
      end
    end
  end

end
