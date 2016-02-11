require __ORIGINAL__

module ActiveRecord
  module Associations
    module ClassMethods
      def has_and_belongs_to_many(name, scope = nil, options = {}, &extension)
        if scope.is_a?(Hash)
          options = scope
          scope   = nil
        end

        habtm_reflection = ActiveRecord::Reflection::HasAndBelongsToManyReflection.new(name, scope, options, self)

        builder = Builder::HasAndBelongsToMany.new name, self, options

        join_model = builder.through_model

        # FIXME: we should move this to the internal constants. Also people
        # should never directly access this constant so I'm not happy about
        # setting it.
        const_set join_model.name, join_model

        middle_reflection = builder.middle_reflection join_model

        Builder::HasMany.define_callbacks self, middle_reflection
        Reflection.add_reflection self, middle_reflection.name, middle_reflection
        middle_reflection.parent_reflection = [name.to_s, habtm_reflection]

        include Module.new {
          define_method :destroy_associations do
            association(middle_reflection.name).delete_all(:delete_all)
            association(name).reset
            super
          end
        }

        hm_options = {}
        hm_options[:through] = middle_reflection.name
        hm_options[:source] = join_model.right_reflection.name

        [:before_add, :after_add, :before_remove, :after_remove, :autosave, :validate, :join_table, :class_name, :extend].each do |k|
          hm_options[k] = options[k] if options.key? k
        end

        has_many name, scope, hm_options, &extension
        self._reflections[name.to_s].parent_reflection = [name.to_s, habtm_reflection]
      end
    end
  end
end
