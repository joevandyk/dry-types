module Dry
  module Types
    module Builder
      def constrained_type
        Constrained
      end

      def |(other)
        Sum.new(self, other)
      end

      def optional
        Types['strict.nil'] | self
      end

      def maybe
        Maybe.new(Types['strict.nil'] | self)
      end

      def constrained(options)
        constrained_type.new(self, rule: Types.Rule(options))
      end

      def default(input = nil, &block)
        value = input ? input : block

        if value.is_a?(Proc) || valid?(value)
          Default[value].new(self, value: value)
        else
          raise ConstraintError, "default value #{value.inspect} violates constraints"
        end
      end

      def enum(*values)
        Enum.new(constrained(inclusion: values), values: values)
      end

      def safe
        Safe.new(self)
      end

      def constructor(constructor, options = {})
        Constructor.new(with(options), fn: constructor)
      end
    end
  end
end

require 'dry/types/default'
require 'dry/types/constrained'
require 'dry/types/enum'
require 'dry/types/maybe'
require 'dry/types/safe'
require 'dry/types/sum'
