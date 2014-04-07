require 'open-uri'
require "goods/version"
require "goods/xml/validator"
require "goods/xml"
require "goods/util"
require "goods/element"
require "goods/container"
require "goods/category"
require "goods/categories_list"
require "goods/offer"
require "goods/offers_list"
require "goods/currency"
require "goods/currencies_list"
require "goods/catalog"

module Goods
  def self.from_string(xml_string, encoding=nil)
    from_io(StringIO.new(xml_string), nil, encoding)
  end

  def self.from_url(url, encoding=nil)
    from_io(load(url), url, encoding)
  end

  def self.from_file(file, encoding=nil)
    from_io(load(file), nil, encoding)
  end

  private

  def self.load(source)
    open source
  end

  def self.from_io(xml_io, url=nil, encoding=nil)
    validator = XML::Validator.new
    if validator.valid? xml_io
      xml_io.rewind
      Catalog.new(io: xml_io, url: url, encoding: encoding)
    else
      raise XML::InvalidFormatError, validator.error
    end
  end
end
