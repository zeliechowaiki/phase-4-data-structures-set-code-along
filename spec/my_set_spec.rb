describe MySet do
  let(:set) { MySet.new([1,2,3]) }

  describe ".new" do
    it "can be initialized with no value" do
      set = MySet.new
      expect(set.instance_variable_get(:@hash)).to eq({})
    end

    it "can be initialized with an array" do
      set = MySet.new([1,2,3])
      expect(set.instance_variable_get(:@hash)).to eq({ 1 => true, 2 => true, 3 => true })
    end
    
    it "can be initialized with a range" do
      set = MySet.new(1..3)
      expect(set.instance_variable_get(:@hash)).to eq({ 1 => true, 2 => true, 3 => true })
    end
  
    it "includes only unique values" do
      set = MySet.new([1,2,2])
      expect(set.instance_variable_get(:@hash)).to eq({ 1 => true, 2 => true })
    end
  end

  describe "#include?" do
    it "returns true if the set contains the given object" do
      expect(set.include?(1)).to eq(true)
    end

    it "returns false if the set does not contain the given object" do
      expect(set.include?(4)).to eq(false)
    end
  end

  describe "#add" do
    it "adds the given object to the set" do
      set.add(4)
      expect(set.instance_variable_get(:@hash)).to eq({ 1 => true, 2 => true, 3 => true, 4 => true })
    end
    
    it "returns the updated set" do
      expect(set.add(4)).to be(set)
    end
  end

  describe "#delete" do
    it "deletes the given object from the set" do
      set.delete(1)
      expect(set.instance_variable_get(:@hash)).to eq({ 2 => true, 3 => true })
    end
    
    it "returns the updated set" do
      expect(set.delete(1)).to be(set)
    end
  end

  describe "#size" do
    it "returns the number of items in the set" do
      expect(set.size).to eq(3)
    end
  end

  # BONUS! Uncomment for an extra challenge.
  describe "Bonus methods ⭐️" do
    describe ".[]" do
      it "can be initialized using bracket notation" do
        set_with_bracket_initializer = MySet[1,2,3]
        expect(set_with_bracket_initializer.instance_variable_get(:@hash)).to eq({ 1 => true, 2 => true, 3 => true })
      end
    end

  describe "#clear" do
    it "removes all the items from the set" do
      set.clear
      expect(set.instance_variable_get(:@hash)).to eq({})
    end
    
    it "returns the updated set" do
      expect(set.clear).to be(set)
    end
  end

    describe "#each" do
      it "iterates over each object in the set" do
        # example use:
        # set.each { |value| puts value }
        expect { |b| set.each(&b) }.to yield_successive_args(1, 2, 3)
      end
  
      it "returns the set" do
        expect(set.each { }).to be(set)
      end
    end
  
    describe "#inspect" do
      it "prints the set in a readable format" do
        expect(set.inspect).to eq("#<MySet: {1, 2, 3}>")
      end
    end
  end
end
