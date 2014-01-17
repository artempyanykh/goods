require "spec_helper"

describe Goods::XML::Validator do
  let(:valid_document) { File.read(File.expand_path("../../../fixtures/simple_catalog.xml", __FILE__)) }
  let(:invalid_document) { File.read(File.expand_path("../../../fixtures/empty_catalog.xml", __FILE__)) }

  describe "#valid?" do
    it "should return true if document is valid according to dtd" do
      validator = Goods::XML::Validator.new(valid_document)
      expect(validator).to be_valid
      expect(validator.errors).to be_empty
    end

    it "should return false if document is not valid" do
      validator = Goods::XML::Validator.new(invalid_document)
      expect(validator).not_to be_valid
    end

    it "should have non-empty errors if document is not valid" do
      validator = Goods::XML::Validator.new(invalid_document)
      validator.valid?
      expect(validator.errors).not_to be_empty
    end
  end
end
