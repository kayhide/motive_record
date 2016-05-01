class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    true
  end
end

Dir[File.expand_path('resources/migrate/**/*.rb')].each { |f| require f }

if RUBYMOTION_ENV != 'test'
  module Utils
    module_function

    def database
      @database ||= "#{RUBYMOTION_ENV}.sqlite3"
    end

    def database= arg
      @database = arg
    end

    def db_use_memory
      @database = ':memory:'
      ActiveRecord::Base.clear_all_connections!
      db_migrate
    end

    def db_drop
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
      if ActiveRecord::Migrator.get_all_versions.any?
        database = ActiveRecord::Base.connection_config[:database]
        mp database
        ActiveRecord::Base.clear_all_connections!
        File.delete database if File.exist? database
      end
    end

    def db_migrate
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
      dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate/books')
      ActiveRecord::Migrator.migrate dir
    end
  end

  Utils.db_migrate
end
