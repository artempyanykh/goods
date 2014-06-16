require 'open-uri'
require_relative "goods/version"
require_relative "goods/xml/validator"
require_relative "goods/xml"
require_relative "goods/util"
require_relative "goods/element"
require_relative "goods/container"
require_relative "goods/category"
require_relative "goods/categories_list"
require_relative "goods/offer"
require_relative "goods/offers_list"
require_relative "goods/currency"
require_relative "goods/currencies_list"
require_relative "goods/catalog"

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
