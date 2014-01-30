shared_examples "element" do
  [:id, :invalid_fields].each do |prop|
    it "should give access to #{prop}" do
      expect(element).to respond_to(prop)
    end
  end

  describe "#reset_validation" do
    it "should clear invalid_fields" do
      element.instance_variable_set("@invalid_fields", [:a, :b])
      expect(element.invalid_fields.size).to eql(2)
      element.send :reset_validation
      expect(element.invalid_fields).to be_empty
    end
  end
end
