require __ORIGINAL__

module Arel
  module Visitors
    class Visitor
      # raise-rescue does not work properly on repl.
      #
      # def visit object
      #   send dispatch[object.class], object
      # rescue NoMethodError => e
      #   raise e if respond_to?(dispatch[object.class], true)
      #   superklass = object.class.ancestors.find { |klass|
      #     respond_to?(dispatch[klass], true)
      #   }
      #   raise(TypeError, "Cannot visit #{object.class}") unless superklass
      #   dispatch[object.class] = dispatch[superklass]
      #   retry
      # end
      def visit object
        if respond_to?(dispatch[object.class], true)
          send dispatch[object.class], object
        else
          superklass = object.class.ancestors.find { |klass|
            respond_to?(dispatch[klass], true)
          }
          raise(TypeError, "Cannot visit #{object.class}") unless superklass

          dispatch[object.class] = dispatch[superklass]
          send dispatch[object.class], object
        end
      end
    end
  end
end
