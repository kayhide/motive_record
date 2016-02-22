module ActiveRecord
  class Migration
    class << self
      attr_accessor :messages
    end
    self.messages = []
  end
end

Module.new do
  def suppress_migration_output
    before do
      ActiveRecord::Migration.messages.clear
      ActiveRecord::Migration.class_eval do
        def puts(*args)
          ActiveRecord::Migration.messages.concat args
        end
      end
    end

    after do
      ActiveRecord::Migration.class_eval do
        remove_method :puts
      end
    end
  end

  Bacon::Context.send :include, self
end
