require "spec_helper"

describe Goods::XML::Validator do
  let(:valid_document) { File.read(File.expand_path("../../../fixtures/simple_catalog.xml", __FILE__)) }
  let(:invalid_document) { File.read(File.expand_path("../../../fixtures/empty_catalog.xml", __FILE__)) }

  describe "#valid?" do
    it "should return true if document is valid according to dtd" do
      validator = Goods::XML::Validator.new
      expect(validator.valid? valid_document).to eql(true)
      expect(validator.error).to be_nil
    end

    it "should return false if document is not valid" do
      validator = Goods::XML::Validator.new
      expect(validator.valid? invalid_document).to eql(false)
    end

    it "should have non-empty errors if document is not valid" do
      validator = Goods::XML::Validator.new
      validator.valid? invalid_document
      expect(validator.error).not_to be_nil
    end
  end
end
