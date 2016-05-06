Module.new do
  def use_database database = 'test.sqlite3'
    after do
      (ActiveRecord::Base.descendants - [ActiveRecord::SchemaMigration]).each do |model|
        model.delete_all
      end
    end
  end

  Bacon::Context.send :include, self
end

database = 'test.sqlite3'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate/books')
ActiveRecord::Migrator.migrate dir
