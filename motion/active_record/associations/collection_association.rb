require __ORIGINAL__

module ActiveRecord
  module Associations
    class CollectionAssociation
      # def reader(force_reload = false)
      #   if force_reload
      #     klass.uncached { reload }
      #   elsif stale_target?
      #     reload
      #   end

      #   if owner.new_record?
      #     # Cache the proxy separately before the owner has an id
      #     # or else a post-save proxy will still lack the id
      #     @new_record_proxy ||= CollectionProxy.create(klass, self)
      #   else
      #     @proxy ||= CollectionProxy.create(klass, self)
      #   end
      # end
      def reader(force_reload = false)
        scope(nullify: false)
      end
    end
  end
end
