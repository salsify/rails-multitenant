module Tins
  module MethodDescription
    def description
      result = ''
      if owner <= Module
        result << receiver.to_s << '.'
      else
        result << owner.name.to_s << '#'
      end
      result << name.to_s << '('
      if respond_to?(:parameters)
        generated_name = 'x0'
        result << parameters.map { |p_type, p_name|
          p_name ||= generated_name.succ!
          case p_type
          when :block
            "&#{p_name}"
          when :rest
            "*#{p_name}"
          when :keyrest
            "**#{p_name}"
          when :req
            p_name
          when :opt
            "#{p_name}="
          when :key
            "#{p_name}:"
          else
            [ p_name, p_type ] * ':'
          end
        } * ','
      else
        result << arity.to_s
      end
      result << ')'
    end
  end
end
