module ActiveRecord
  module Delegation # :nodoc:
    module DelegateCache
      def relation_delegate_class(klass) # :nodoc:
        @relation_delegate_cache[klass]
      end

      def initialize_relation_delegate_cache # :nodoc:
        @relation_delegate_cache = cache = {}
        [
          ActiveRecord::Relation,
          ActiveRecord::Associations::CollectionProxy,
          ActiveRecord::AssociationRelation
        ].each do |klass|
          delegate = Class.new(klass) {
            include ClassSpecificRelation
          }
          const_set klass.name.gsub('::', '_'), delegate
          cache[klass] = delegate
        end
      end

      def inherited(child_class)
        child_class.initialize_relation_delegate_cache
        super
      end
    end
  end
end
