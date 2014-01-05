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
      expect(Nokogiri::XML::Document).to receive(:parse).with(*params)

      Goods::XML.new(*params)
    end

    it 'should parse valid document' do
      expect(simple_catalog.instance_variable_get("@xml_source")).to be_kind_of(Nokogiri::XML::Document)
    end
  end

  describe "#categories" do
    let(:categories) { simple_catalog.categories }

    it "should extract all categories" do
      expect(categories.count).to eq(SIMPLE_CATALOG_CATEGORIES_COUNT)
    end

    context "category format" do
      let(:root_category) { categories[0] }
      let(:child_category) { categories[1] }

      it "should have an id" do
        expect(root_category[:id]).to eq("1")
      end

      it "should have a name" do
        expect(root_category[:name]).to eq("Оргтехника")
      end

      it "should have nil parent_id for root category" do
        expect(root_category[:parent_id]).to be_nil
      end

      it "should have non-nil parent_id for child_category" do
        expect(child_category[:parent_id]).to eq("1")
      end
    end

    it 'should call #extract_categories only at the first invocation' do
      expect_any_instance_of(Goods::XML).to receive(:extract_categories).once.and_call_original
      2.times { simple_catalog.categories }
    end
  end

  describe "#currencies" do
    it "should extract all currencies" do
      expect(simple_catalog.currencies.count).to eq(SIMPLE_CATALOG_CURRENCIES_COUNT)
    end

    context "currency format" do
      let(:rur) { simple_catalog.currencies[0] }
      let(:usd) { simple_catalog.currencies[1] }
      let(:kzt) { simple_catalog.currencies[2] }

      it "should have an id" do
        expect(rur[:id]).to eq("RUR")
      end

      it "should have a rate" do
        expect(rur[:rate]).to eq("1")
      end

      it "should have a custom rate" do
        expect(usd[:rate]).to eq("30")
      end

      it "should have a default rate" do
        expect(kzt[:rate]).to eq("1")
      end

      it "should have a plus" do
        expect(rur[:plus]).to eq("0")
      end

      it "should have a default plus" do
        expect(kzt[:plus]).to eq("0")
      end
    end

    it 'should call #extract_currencies only at the first invocation' do
      expect_any_instance_of(Goods::XML).to receive(:extract_currencies).once.and_call_original
      2.times { simple_catalog.currencies }
    end
  end

  describe "#offers" do
    it 'should extract all offers' do
      expect(simple_catalog.offers.count).to eq(SIMPLE_CATALOG_OFFERS_COUNT)
    end

    context "offer format" do
      let(:printer) { simple_catalog.offers[0] }
      let(:book) { simple_catalog.offers[1] }

      it "should have an id" do
        expect(printer[:id]).to eq("123")
      end

      it "should have availability status" do
        expect(book[:available]).to eq(false)
      end

      it "should have default availability status" do
        expect(printer[:available]).to eq(true)
      end

      it "should have a URL which is not empty" do
        expect(printer[:url]).to eq("http://magazin.ru/product_page.asp?pid=14344")
      end

      it "should have a nil URL if offer doesn't have one" do
        expect(book[:url]).to be_nil
      end

      it "should have a price" do
        expect(printer[:price]).to eq(15000.00)
      end

      it "should have a currency_id" do
        expect(printer[:currency_id]).to eq("RUR")
      end

      it "should use first category_id" do
        expect(printer[:category_id]).to eq("100")
      end

      it "should use first picture if there at least one" do
        expect(printer[:picture]).to eq("http://magazin.ru/img/device1.jpg")
      end

      it "should have a nil picture if offer doesn't have one" do
        expect(book[:picture]).to be_nil
      end

      it "should have a description" do
        expect(printer[:description]).to eq("A4, 64Mb, 600x600 dpi, USB 2.0, 29стр/мин ч/б / 15стр/мин цв, лотки на 100л и 250л, плотность до 175г/м, до 60000 стр/месяц")
      end

      it "should have a non-empty name" do
        expect(book[:name]).to eq("Все не так. В 2 томах. Том 1")
      end

      it "should have a nil name if offer doesn't have one" do
        expect(printer[:name]).to be_nil
      end

      it "should have a non-empty vendor" do
        expect(printer[:vendor]).to eq("НP")
      end

      it "should have a nil vendor if offer doesn't have one" do
        expect(book[:vendor]).to be_nil
      end

      it "should have a non-empty model" do
        expect(printer[:model]).to eq("Color LaserJet 3000")
      end

      it "should have a nil model if offer doesn't have one" do
        expect(book[:model]).to be_nil
      end
    end
  end
end
