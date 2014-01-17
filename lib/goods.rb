require 'open-uri'
require "goods/version"
require "goods/xml/validator"
require "goods/xml"
require "goods/containable"
require "goods/container"
require "goods/category"
require "goods/categories_list"
require "goods/offer"
require "goods/offers_list"
require "goods/currency"
require "goods/currencies_list"
require "goods/catalog"

module Goods
  def self.from_string(xml_string, url=nil, encoding=nil)
    validator = XML::Validator.new
    if validator.valid? xml_string
      Catalog.new(string: xml_string, url: url, encoding: encoding)
    else
      raise XML::InvalidFormatError, validator.error
    end
  end

  def self.from_url(url, encoding=nil)
    xml_string = self.load url
    from_string(xml_string, url, encoding)
  end

  def self.from_file(file, encoding=nil)
    xml_string = self.load file
    from_string(xml_string, nil, encoding)
  end

  private

  def self.load(source)
    open(source) do |f|
      f.read
    end
  end
end
