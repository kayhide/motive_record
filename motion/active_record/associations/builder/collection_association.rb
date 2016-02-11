require __ORIGINAL__

module ActiveRecord::Associations::Builder
  class CollectionAssociation < Association
    def self.define_readers(mixin, name)
      super

      mixin.class_eval do
        define_method "#{name.to_s.singularize}_ids" do
          association(name).ids_reader
        end
      end
    end

    def self.define_writers(mixin, name)
      super

      mixin.class_eval do
        define_method "#{name.to_s.singularize}_ids=" do |ids|
          association(name).ids_writer(ids)
        end
      end
    end
  end
end
