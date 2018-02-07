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
end
