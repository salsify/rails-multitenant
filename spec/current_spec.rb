describe RailsMultitenant::GlobalContextRegistry::Current do

  class TestClass
    include RailsMultitenant::GlobalContextRegistry::Current

    attr_accessor :id

    def initialize(id: :default)
      @id = id
    end
  end

  class DependentClass
    include RailsMultitenant::GlobalContextRegistry::Current
    global_context_dependent_on TestClass
  end

  describe 'current' do
    it 'default constructs the object' do
      expect(TestClass.current.id).to eq(:default)
    end
  end

  describe 'current=' do
    it 'stores the provided object' do
      provided = TestClass.new(id: :provided)
      TestClass.current = provided
      expect(TestClass.current).to equal(provided)
    end

    it 'clears dependencies' do
      dependent = DependentClass.current
      TestClass.current = TestClass.new
      expect(DependentClass.current).not_to equal(dependent)
    end
  end

  describe 'current?' do
    it 'returns false when uninitialized' do
      TestClass.clear_current!
      expect(TestClass.current?).to be false
    end

    it 'returns true when initialized' do
      TestClass.current = TestClass.new
      expect(TestClass.current?).to be true
    end
  end

  describe 'as_current' do
    let(:test_class1) { TestClass.new }
    let(:test_class2) { TestClass.new }

    it 'sets and restores current' do
      TestClass.current = test_class1
      TestClass.as_current(test_class2) do
        expect(TestClass.current).to equal(test_class2)
      end
      expect(TestClass.current).to equal(test_class1)
    end
  end

  context 'instance methods' do
    describe 'current?' do
      it 'returns false when not the current instance' do
        TestClass.clear_current!
        expect(TestClass.new.current?).to be false

        TestClass.current = TestClass.new
        expect(TestClass.new.current?).to be false
      end

      it 'returns true when it is the current instance' do
        test_class = TestClass.new
        TestClass.current = test_class
        expect(test_class.current?).to be true
      end
    end

    describe 'as_current' do
      let(:test_class1) { TestClass.new }
      let(:test_class2) { TestClass.new }

      it 'sets and restores current' do
        TestClass.current = test_class1
        test_class2.as_current do
          expect(TestClass.current).to equal(test_class2)
        end
        expect(TestClass.current).to equal(test_class1)
      end
    end
  end
end
