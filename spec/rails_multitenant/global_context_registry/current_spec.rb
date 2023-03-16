# frozen_string_literal: true

class TestClass
  include RailsMultitenant::GlobalContextRegistry::Current
  provide_default :new

  attr_accessor :id

  def initialize(id: :default)
    @id = id
  end
end

describe RailsMultitenant::GlobalContextRegistry::Current do
  before do
    stub_const('SubClass', Class.new(TestClass))
    stub_const('DependentClass', dependent_class)
    stub_const('CyclicallyDependentClass1', cyclically_dependent_class1)
    stub_const('CyclicallyDependentClass2', cyclically_dependent_class2)
    stub_const('BiDependentClass', bidependent_class)
    stub_const('NoDefaultTestClass', no_default_test_class)

    DependentClass.global_context_dependent_on TestClass
    DependentClass.global_context_dependent_on CyclicallyDependentClass2
    CyclicallyDependentClass1.global_context_dependent_on DependentClass
    CyclicallyDependentClass2.global_context_dependent_on CyclicallyDependentClass1
    BiDependentClass.global_context_mutually_dependent_on TestClass
  end

  let(:dependent_class) do
    Class.new do
      include RailsMultitenant::GlobalContextRegistry::Current
      provide_default { new }
    end
  end

  let(:cyclically_dependent_class1) do
    Class.new do
      include RailsMultitenant::GlobalContextRegistry::Current
      provide_default { new }
    end
  end

  let(:cyclically_dependent_class2) do
    Class.new do
      include RailsMultitenant::GlobalContextRegistry::Current
      provide_default { new }
    end
  end

  let(:bidependent_class) do
    Class.new do
      include RailsMultitenant::GlobalContextRegistry::Current
      provide_default { new }
    end
  end

  let(:no_default_test_class) do
    Class.new do
      include RailsMultitenant::GlobalContextRegistry::Current
    end
  end

  describe "current" do
    it "returns default value when supplied" do
      expect(TestClass.current.id).to eq(:default)
      expect(SubClass.current.id).to eq(:default)
    end

    it "returns nil when no default supplied" do
      expect(NoDefaultTestClass.current).to be_nil
    end
  end

  describe "current!" do
    it "returns current value when set" do
      expect(TestClass.current.id).to eq(:default)
    end

    it "raises an error when current not set" do
      NoDefaultTestClass.clear_current!
      expect { NoDefaultTestClass.current! }.to raise_error('No current NoDefaultTestClass set')
    end
  end

  describe "current=" do
    it "stores the provided object" do
      provided = TestClass.new(id: :provided)
      TestClass.current = provided
      expect(TestClass.current).to equal(provided)
    end

    it "clears dependencies" do
      dependent = DependentClass.current
      cyclically_dependent1 = CyclicallyDependentClass1.current
      cyclically_dependent2 = CyclicallyDependentClass1.current

      TestClass.current = TestClass.new
      expect(DependentClass.current).not_to equal(dependent)
      expect(CyclicallyDependentClass1.current).not_to equal(cyclically_dependent1)
      expect(CyclicallyDependentClass2.current).not_to equal(cyclically_dependent2)
    end

    it "clears bidirectional dependencies" do
      dependent = BiDependentClass.current
      TestClass.current = test_class = TestClass.new
      expect(BiDependentClass.current).not_to equal(dependent)

      BiDependentClass.current = BiDependentClass.new
      expect(TestClass.current).not_to equal(test_class)
    end
  end

  describe "current?" do
    it "returns false when uninitialized" do
      TestClass.clear_current!
      expect(TestClass.current?).to be false
    end

    it "returns true when initialized" do
      TestClass.current = TestClass.new
      expect(TestClass.current?).to be true
    end
  end

  describe "as_current" do
    let(:test_class1) { TestClass.new }
    let(:test_class2) { TestClass.new }

    it "sets and restores current" do
      TestClass.current = test_class1
      TestClass.as_current(test_class2) do
        expect(TestClass.current).to equal(test_class2)
      end
      expect(TestClass.current).to equal(test_class1)
    end
  end

  context "instance methods" do
    describe "current?" do
      it "returns false when not the current instance" do
        TestClass.clear_current!
        expect(TestClass.new.current?).to be false

        TestClass.current = TestClass.new
        expect(TestClass.new.current?).to be false
      end

      it "returns true when it is the current instance" do
        test_class = TestClass.new
        TestClass.current = test_class
        expect(test_class.current?).to be true
      end
    end

    describe "as_current" do
      let(:test_class1) { TestClass.new }
      let(:test_class2) { TestClass.new }

      it "sets and restores current" do
        TestClass.current = test_class1
        test_class2.as_current do
          expect(TestClass.current).to equal(test_class2)
        end
        expect(TestClass.current).to equal(test_class1)
      end
    end
  end
end
