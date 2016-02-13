module Arel
  module Nodes
    class Values < Arel::Nodes::Binary
      # alias :expressions :left
      # alias :expressions= :left=
      # alias :columns :right
      # alias :columns= :right=
      def expressions; left; end
      def expressions= arg; self.left = arg; end
      def columns; right; end
      def columns= arg; self.right = arg; end

      def initialize exprs, columns = []
        super
      end
    end
  end
end
