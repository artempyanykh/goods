# Goods

The purpose of this gem is to provide simple, yet reliable solution for parsing
YML (Yandex Market Language) files, with clean and convenient interface,
and a few extra capabilites, such as categories prunning.

## Installation

Add this line to your application's Gemfile:

    gem 'goods'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install goods

## Usage

1. **How to parse YML-catalog**:
		
		begin
			catalog = Goods.from_string(xml, url, encoding)
			[ or Goods.from_url(url, encoding) ]
			[ or Goods.from_file(io, encoding) ]
		rescue Goods::XML::InvalidFormatError => e
			#do something
		end
	
	* `encoding` is optional;
	* `url` is optional when parsing string;
		
2. **How to iterate over offers**:

		catalog.offers.each do |offer|
			offer.id # => "some id"
			offer.category # => <Goods::Category>
			offer.currency # => <Goods::Currency>
			offer.price # => 50.0 (for example)
			etc...
		end
3. **How to iterate over categories**:
		
		catalog.categories.each do |category|
			category.id # => "some id"
			category.name # => "some name"
			category.parent # => <Goods::Category> or nil
			etc...
		end
		
4. **How to iterate over currencies**:
		
		catalog.currencies.each do |currency|
			currency.id # => "RUR"
			currency.rate # => 1.00 or 30.00 or some other float
			etc...
		end
		
5. **How to get a single element from the collection**:

	If you know an ID of an object, you may act like this
	
		(for example, let's take currencies)
		rur = catalog.currencies.find("RUR") # => <Goods::Curency>
		rur.rate # => 1.00

6. **How to prune categories in a whole catalog**:
		
		catalog.prune(level_of_pruning)
	
	It will replace all categories with level greater than `level_of_pruning` with their parents at that level.
	
	What is the purpose of prunning? For example, with very deep categories structure it may be very costly in terms of performance to mirror this structure in your database. It may be sufficient to have a representation with lower level of details.	
	
7. **How to convert currencies and prices for a whole catalog**:

		rur = catalog.currencies.find("RUR")
		catalog.convert_currency(rur)
		
	It will convert all prices and change `currency` for every offer.
	
8. **But what's with invalid elements**:
	
	General validation is performed according to DTD spec., and guarantees that you will have all the fields, that you're expecting to find in a YML-catalog. However, there can be somewhat trickier inconsistencies in YML-files, like offer having non-existing category_id, or currency_id.
	
	All that valid (according to DTD), but defective elements are saved under `defectives` property of a collection. Each defective element has `invalid_field` property. For example:
		
		defectives = catalog.offers.defectives # => Array of Goods::Offer
		defectives.first.invalid_fields # => [:category_id, :currency_id]
		
9. **Is that all?**

	No, it is not. For more information look at the source code.
	
	
## Contributing

At current time, Goods::Offer is quite incomplete, and works only with properties, that I need. Generalization of Goods::Offer is welcome!

**So**:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
