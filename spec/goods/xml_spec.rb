require 'spec_helper'

describe Goods::XML do
  let(:simple_catalog_data) do
    File.read(File.expand_path('../../fixtures/simple_catalog.xml', __FILE__))
  end
  let(:simple_catalog) { Goods::XML.new(simple_catalog_data) }
  SIMPLE_CATALOG_CATEGORIES_COUNT = 9
  SIMPLE_CATALOG_CURRENCIES_COUNT = 3
  SIMPLE_CATALOG_OFFERS_COUNT = 2

  describe "#initialize" do
    it 'should use Nokogiri for parsing' do
      params = ["string", "url", "encoding"]
      Nokogiri::XML::Document.should_receive(:parse).with(*params)

      Goods::XML.new(*params)
    end

    it 'should parse valid document' do
      simple_catalog.instance_variable_get("@xml_source").should be_kind_of(Nokogiri::XML::Document)
    end
  end

  describe "#categories" do
    let(:categories) { simple_catalog.categories }

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
      2.times { simple_catalog.categories }
    end
  end

  describe "#currencies" do
    it "should extract all currencies" do
      simple_catalog.currencies.count.should == SIMPLE_CATALOG_CURRENCIES_COUNT
    end

    context "currency format" do
      let(:rur) { simple_catalog.currencies[0] }
      let(:usd) { simple_catalog.currencies[1] }
      let(:kzt) { simple_catalog.currencies[2] }

      it "should have an id" do
        rur[:id].should == "RUR"
      end

      it "should have a rate" do
        rur[:rate].should == "1"
      end

      it "should have a custom rate" do
        usd[:rate].should == "30"
      end

      it "should have a default rate" do
        kzt[:rate].should == "1"
      end

      it "should have a plus" do
        rur[:plus].should == "0"
      end

      it "should have a default plus" do
        kzt[:plus].should == "0"
      end
    end

    it 'should call #extract_currencies only at the first invocation' do
      Goods::XML.any_instance.should_receive(:extract_currencies).once.and_call_original
      2.times { simple_catalog.currencies }
    end
  end

  describe "#offers" do
    it 'should extract all offers' do
      simple_catalog.offers.count.should == SIMPLE_CATALOG_OFFERS_COUNT
    end

    context "offer format" do
      let(:printer) { simple_catalog.offers[0] }
      let(:book) { simple_catalog.offers[1] }

      it "should have an id" do
        printer[:id].should == "123"
      end

      it "should have availability status" do
        book[:available].should == false
      end

      it "should have default availability status" do
        printer[:available].should == true
      end

      it "should have a URL which is not empty" do
        printer[:url].should == "http://magazin.ru/product_page.asp?pid=14344"
      end

      it "should have a nil URL if offer doesn't have one" do
        book[:url].should be_nil
      end

      it "should have a price" do
        printer[:price].should == 15000.00
      end

      it "should have a currency_id" do
        printer[:currency_id].should == "RUR"
      end

      it "should use first category_id" do
        printer[:category_id].should == "100"
      end

      it "should use first picture if there at least one" do
        printer[:picture].should == "http://magazin.ru/img/device1.jpg"
      end

      it "should have a nil picture if offer doesn't have one" do
        book[:picture].should be_nil
      end

      it "should have a description" do
        printer[:description].should == "A4, 64Mb, 600x600 dpi, USB 2.0, 29стр/мин ч/б / 15стр/мин цв, лотки на 100л и 250л, плотность до 175г/м, до 60000 стр/месяц"
      end

      it "should have a non-empty name" do
        book[:name].should == "Все не так. В 2 томах. Том 1"
      end

      it "should have a nil name if offer doesn't have one" do
        printer[:name].should be_nil
      end

      it "should have a non-empty vendor" do
        printer[:vendor].should == "НP"
      end

      it "should have a nil vendor if offer doesn't have one" do
        book[:vendor].should be_nil
      end

      it "should have a non-empty model" do
        printer[:model].should == "Color LaserJet 3000"
      end

      it "should have a nil model if offer doesn't have one" do
        book[:model].should be_nil
      end
    end
  end
end
