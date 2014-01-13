require 'spec_helper'

describe Goods::CurrenciesList do
  it_should_behave_like "a container", Goods::Currency, Goods::Currency.new(id: "1", name: "RUR", rate: 1, plus: 0)
end
