module Arel
  module Nodes
    class Equality < Arel::Nodes::Binary
      def operator; :== end
      # alias :operand1 :left
      # alias :operand2 :right
      def operand1; left; end
      def operand2; right; end
    end
  end
end
