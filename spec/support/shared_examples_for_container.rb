shared_examples "a container" do |containable_class|
  let(:an_element) do
    instance_double(containable_class, :kind_of? => true, :valid? => true, :id => 1)
  end

  describe "#add" do
    context "when hash is passed" do
      it "should at first create an object" do
        expect(containable_class).to receive(:new) { double :valid? => true, id: 1 }
        subject.add({})
      end
    end

    context "when object is passed" do
      it "should not create new object" do
        expect(containable_class).to_not receive(:new)
        subject.add an_element
      end

      it "should add to list valid elements" do
        expect { subject.add(an_element) }.to change(subject, :size).by(1)
      end

      it "should remember invalid elements" do
        allow(an_element).to receive(:valid?).and_return(false)
        expect { subject.add(an_element) }.to change(subject.defectives, :size).by(1)
      end
    end
  end

  describe "#find" do
    [:one, :two].each do |el|
      let(el) { instance_double containable_class, :kind_of? => true, :valid? => true, :id => el.to_s.upcase }
    end

    it "should return element with correct id" do
      subject.add(one); subject.add(two)
      expect(subject.size).to eq(2)
      expect(subject.find(one.id)).to eq(one)
    end
  end
end
