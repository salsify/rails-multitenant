require 'helper'

class TestCommandGuesser < Test::Unit::TestCase
  on_ruby '1.9' do
    def self.should_guess_command_name(expectation, *argv)
      argv.each do |args|
        should "return '#{expectation}' for '#{args}'" do
          SimpleCov::CommandGuesser.original_run_command = args
          assert_equal expectation, SimpleCov::CommandGuesser.guess
        end
      end
    end

    should_guess_command_name "Unit Tests", '/some/path/test/units/foo_bar_test.rb', 'test/units/foo.rb', 'test/foo.rb'
    should_guess_command_name "Functional Tests", '/some/path/test/functional/foo_bar_controller_test.rb'
    should_guess_command_name "Integration Tests", '/some/path/test/integration/foo_bar_controller_test.rb'
    should_guess_command_name "Cucumber Features", 'features', 'cucumber', 'cucumber features'
    should_guess_command_name "RSpec", '/some/path/spec/foo.rb'
    should_guess_command_name "Unit Tests", 'some_arbitrary_command with arguments' # Because Test::Unit const is defined!
  end
end
