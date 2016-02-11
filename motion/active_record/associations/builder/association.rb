require __ORIGINAL__

module ActiveRecord::Associations::Builder
  class Association
    def self.define_readers(mixin, name)
      mixin.class_eval do
        define_method name do |*args|
          association(name).reader(*args)
        end
      end
    end

    def self.define_writers(mixin, name)
      mixin.class_eval do
        define_method "#{name}=" do |value|
          association(name).writer(value)
        end
      end
    end
  end
end
