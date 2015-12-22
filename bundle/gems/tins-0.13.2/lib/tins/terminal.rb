require 'tins/xt/ask_and_send'

begin
  require 'io/console'
rescue LoadError
end

module Tins
  module Terminal

    module_function

    def rows
      IO.ask_and_send(:console).ask_and_send(:winsize).ask_and_send(:[], 0) ||
        `stty size 2>/dev/null`.split[0].to_i.nonzero? ||
        `tput lines 2>/dev/null`.to_i.nonzero? ||
        25
    end

    def lines
      rows
    end

    def columns
      IO.ask_and_send(:console).ask_and_send(:winsize).ask_and_send(:[], 1) ||
        `stty size 2>/dev/null`.split[1].to_i.nonzero? ||
        `tput cols 2>/dev/null`.to_i.nonzero? ||
        80
    end

    def cols
      columns
    end
  end
end
