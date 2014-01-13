shared_examples "a container" do |containable_class, element|
  describe "#add" do
    context "when hash is passed" do
      it "should at first create an object" do
        expect(containable_class).to receive(:new) { element }
        subject.add({})
      end
    end

    context "when object is passed" do
      it "should not create new object" do
        expect(containable_class).to_not receive(:new)
        subject.add element
      end

      it "should add to list valid elements" do
        expect { subject.add(element) }.to change(subject, :size).by(1)
      end

      it "should remember invalid elements" do
        allow(element).to receive(:valid?).and_return(false)
        expect { subject.add(element) }.to change(subject.defectives, :size).by(1)
      end
    end
  end

  describe "#find" do
    [:one, :two].each do |el|
      let(el) { 
        el = containable_class.new({})
        allow(el).to receive(:valid?) { true }
        allow(el).to receive(:id) { el.to_s.upcase }
        el
      }
    end

    it "should return element with correct id" do
      subject.add(one); subject.add(two)
      expect(subject.size).to eq(2)
      expect(subject.find(one.id)).to eq(one)
    end
  end
end
