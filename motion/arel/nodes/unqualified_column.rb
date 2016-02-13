module Arel
  module Nodes
    class UnqualifiedColumn < Arel::Nodes::Unary
      # alias :attribute :expr
      # alias :attribute= :expr=
      def attribute; expr; end
      def attribute= arg; self.expr = arg; end

      def relation
        @expr.relation
      end

      def column
        @expr.column
      end

      def name
        @expr.name
      end
    end
  end
end
