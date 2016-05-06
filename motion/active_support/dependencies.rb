require 'thread_safe'
require 'active_support/inflector'

module ActiveSupport #:nodoc:
  module Dependencies #:nodoc:
    extend self

    class ClassCache
      def initialize
        @store = ThreadSafe::Cache.new
      end

      def empty?
        @store.empty?
      end

      def key?(key)
        @store.key?(key)
      end

      def get(key)
        key = key.name if key.respond_to?(:name)
        @store[key] ||= Inflector.constantize(key)
      end
      alias :[] :get

      def safe_get(key)
        key = key.name if key.respond_to?(:name)
        @store[key] ||= Inflector.safe_constantize(key)
      end

      def store(klass)
        return self unless klass.respond_to?(:name)
        raise(ArgumentError, 'anonymous classes cannot be cached') if klass.name.empty?
        @store[klass.name] = klass
        self
      end

      def clear!
        @store.clear
      end
    end

    Reference = ClassCache.new

    # Store a reference to a class +klass+.
    def reference(klass)
      Reference.store klass
    end

    # Get the reference for class named +name+.
    # Raises an exception if referenced class does not exist.
    def constantize(name)
      Reference.get(name)
    end

    # Get the reference for class named +name+ if one exists.
    # Otherwise returns +nil+.
    def safe_constantize(name)
      Reference.safe_get(name)
    end
  end
end
