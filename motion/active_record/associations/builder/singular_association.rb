require __ORIGINAL__

module ActiveRecord::Associations::Builder
  class SingularAssociation < Association
    def self.define_constructors(mixin, name)
      mixin.class_eval do
        define_method "build_#{name}" do |*args, &block|
          association(name).build(*args, &block)
        end

        define_method "create_#{name}" do |*args, &block|
          association(name).create(*args, &block)
        end

        define_method "create_#{name}!" do |*args, &block|
          association(name).create!(*args, &block)
        end
      end
    end
  end
end
