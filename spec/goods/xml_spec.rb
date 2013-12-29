require 'spec_helper'

describe Goods::XML do
  let(:simple_catalog) do
    File.read(File.expand_path('../../fixtures/simple_catalog.xml', __FILE__))
  end
  SIMPLE_CATALOG_CATEGORIES_COUNT = 19

  describe "#initialize" do
    it 'should use Nokogiri for parsing' do
      params = ["string", "url", "encoding"]
      Nokogiri::XML::Document.should_receive(:parse).with(*params)

      Goods::XML.new(*params)
    end

    it 'should parse valid document' do
      xml = Goods::XML.new(simple_catalog)
      xml.instance_variable_get("@xml_source").should be_kind_of(Nokogiri::XML::Document)
    end
  end

  describe "#categories" do
    let(:subject) { Goods::XML.new(simple_catalog) }
    let(:categories) { subject.categories }

    it "should extract all categories" do
      categories.count.should == SIMPLE_CATALOG_CATEGORIES_COUNT
    end

    context "category format" do
      let(:root_category) { categories[0] }
      let(:child_category) { categories[1] }

      it "should have an id" do
        root_category[:id].should == "1"
      end

      it "should have a name" do
        root_category[:name].should == 'Оргтехника'
      end

      it "should have nil parent_id for root category" do
        root_category[:parent_id].should be_nil
      end

      it "should have non-nil parent_id for child_category" do
        child_category[:parent_id].should == "1"
      end
    end

    it 'should call #extract_categories only at the first invocation' do
      Goods::XML.any_instance.should_receive(:extract_categories).once.and_call_original
      2.times { subject.categories }
    end
  end
end
