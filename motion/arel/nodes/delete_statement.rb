module Arel
  module Nodes
    class DeleteStatement < Arel::Nodes::Binary
      # alias :relation :left
      # alias :relation= :left=
      # alias :wheres :right
      # alias :wheres= :right=
      def relation; left; end
      def relation= arg; self.left = arg; end
      def wheres; right; end
      def wheres= arg; self.right = arg; end

      def initialize relation = nil, wheres = []
        super
      end

      def initialize_copy other
        super
        @right = @right.clone
      end
    end
  end
end
