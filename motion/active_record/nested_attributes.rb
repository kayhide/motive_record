require __ORIGINAL__

module ActiveRecord
  module NestedAttributes
    module ClassMethods
      def generate_association_writer(association_name, type)
        generated_association_methods.module_eval do
          if method_defined? "#{association_name}_attributes="
            remove_method("#{association_name}_attributes=")
          end
          define_method "#{association_name}_attributes=" do |attributes|
            send "assign_nested_attributes_for_#{type}_association", association_name, attributes
          end
        end
      end
    end
  end
end
