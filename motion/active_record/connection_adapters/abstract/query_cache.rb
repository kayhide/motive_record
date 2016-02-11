require __ORIGINAL__

module ActiveRecord
  module ConnectionAdapters
    module QueryCache
      class << self
        def dirties_query_cache(base, *method_names)
          method_names.each do |method_name|
            define_method method_name do
              clear_query_cache if @query_cache_enabled
              super
            end
          end
        end
      end
    end
  end
end
