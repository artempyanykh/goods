require 'spec_helper'

describe Goods do
  it 'should have a version number' do
    expect(Goods::VERSION).to_not be_nil
  end

  describe ".from_io" do
    let(:valid_document) { open File.expand_path("../fixtures/simple_catalog.xml", __FILE__) }
    let(:invalid_document) { open File.expand_path("../fixtures/empty_catalog.xml", __FILE__) }

    it "should return catalog if valid xml io is passed" do
      expect(Goods::Catalog).to receive(:new).
        with({io: valid_document, url: "url", encoding: "UTF-8"})
      Goods.from_io(valid_document, "url", "UTF-8")
    end

    it "should raise error if invalid xml io is passed" do
      expect { Goods.from_io(invalid_document) }.to raise_error(Goods::XML::InvalidFormatError)
    end
  end

  describe ".from_file" do
    it "should load file and call .from_io" do
      params = {
        file: "file", string: "string", url: nil, encoding: "UTF-8"
      }
      expect(Goods).to receive(:load).with(params[:file]) { params[:string] }
      expect(Goods).to receive(:from_io).with(params[:string], nil, params[:encoding])
      Goods.from_file params[:file], params[:encoding]
    end
  end

  describe ".from_url" do
    it "should load remote page and call .from_io" do
      params = {
        string: "string", url: "url", encoding: "UTF-8"
      }
      expect(Goods).to receive(:load).with(params[:url]) { params[:string] }
      expect(Goods).to receive(:from_io).with(params[:string], params[:url], params[:encoding])
      Goods.from_url params[:url], params[:encoding]
    end
  end

  describe ".from_string" do
    it "should load string and call .from_io" do
      params = {
        string: "string", encoding: "UTF-8"
      }
      expect(Goods).to receive(:from_io)
      Goods.from_string params[:string], params[:encoding]
    end
  end
end
