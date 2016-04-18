Module.new do
  def use_database database
    if database == :memory
      before do
        database = ':memory:'
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
      end

      after do
        ActiveRecord::Base.clear_all_connections!
      end
    else
      before do
        support_dir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true).first
        database = File.expand_path(database, support_dir)
        File.delete database if File.exist? database
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
      end

      after do
        ActiveRecord::Base.clear_all_connections!
        database = ActiveRecord::Base.connection_config[:database]
        File.delete database if File.exist? database
      end
    end
  end

  def use_migration name, &proc
    before do
      dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate', name.to_s)
      ActiveRecord::Migrator.migrate dir
    end
  end
  Bacon::Context.send :include, self
end
