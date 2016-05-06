describe ActiveRecord::Migrator do
  suppress_migration_output

  describe 'with on-memory database' do
    before do
      @old_database = ActiveRecord::Base.connection_config[:database]
      ActiveRecord::Base.clear_all_connections!

      database = ':memory:'
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
    end

    after do
      ActiveRecord::Base.clear_all_connections!
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: @old_database)
    end

    describe '#migrate' do
      it 'migrates with migration files' do
        dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate/books')
        ActiveRecord::Migrator.migrate dir
        ActiveRecord::SchemaMigration.count.should == 2
      end
    end
  end

  describe 'with file database' do
    before do
      @old_database = ActiveRecord::Base.connection_config[:database]
      ActiveRecord::Base.clear_all_connections!

      database = 'test-migration.sqlite3'
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
    end

    after do
      database = ActiveRecord::Base.connection_config[:database]
      ActiveRecord::Base.clear_all_connections!
      File.delete database
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: @old_database)
    end


    describe '#migrate' do
      it 'migrates with migration files' do
        dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate/books')
        ActiveRecord::Migrator.migrate dir
        ActiveRecord::SchemaMigration.count.should == 2
      end
    end
  end
end
