Module.new do
  def use_database database
    before do
      if database == :memory
        database = ':memory:'
      else
        support_dir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true).first
        database = File.expand_path(database, support_dir)
        File.delete database if File.exist? database
      end

      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
    end
  end

  def use_migration dir = nil, &proc
    before do
    end

    after do
    end
  end
  Bacon::Context.send :include, self
end
