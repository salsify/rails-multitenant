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
  let(:sub_class) do
    Class.new(TestClass) do
      def self.name
        'SubClass'
      end
    end
  end

  let(:dependent_class) do
    Class.new do
      include RailsMultitenant::GlobalContextRegistry::Current
      provide_default { new }
      global_context_dependent_on TestClass

      def self.name
        'DependentClass'
      end
    end
  end

  let(:no_default_test_class) do
    Class.new do
      include RailsMultitenant::GlobalContextRegistry::Current

      def self.name
        'NoDefaultTestClass'
      end
    end
  end

  describe "current" do
    it "returns default value when supplied" do
      expect(TestClass.current.id).to eq(:default)
      expect(sub_class.current.id).to eq(:default)
    end

    it "returns nil when no default supplied" do
      expect(no_default_test_class.current).to be_nil
    end
  end

  describe "current!" do
    it "returns current value when set" do
      expect(TestClass.current.id).to eq(:default)
    end

    it "raises an error when current not set" do
      no_default_test_class.clear_current!
      expect { no_default_test_class.current! }.to raise_error('No current NoDefaultTestClass set')
    end
  end

  describe "current=" do
    it "stores the provided object" do
      provided = TestClass.new(id: :provided)
      TestClass.current = provided
      expect(TestClass.current).to equal(provided)
    end

    it "clears dependencies" do
      dependent = dependent_class.current
      TestClass.current = TestClass.new
      expect(dependent_class.current).not_to equal(dependent)
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
