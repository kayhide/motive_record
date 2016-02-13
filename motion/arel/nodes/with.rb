module Arel
  module Nodes
    class With < Arel::Nodes::Unary
      # alias children expr
      def children; expr; end
    end

    class WithRecursive < With; end
  end
end

