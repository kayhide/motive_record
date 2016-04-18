describe ActiveRecord::Migrator do
  suppress_migration_output

  describe 'with on-memory database' do
    use_database :memory

    describe '#migrate' do
      it 'migrates with migration files' do
        dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate/books')
        ActiveRecord::Migrator.migrate dir
        ActiveRecord::SchemaMigration.count.should == 1
      end
    end
  end

  describe 'with file database' do
    use_database 'test.sqlite'

    describe '#migrate' do
      it 'migrates with migration files' do
        dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate/books')
        ActiveRecord::Migrator.migrate dir
        ActiveRecord::SchemaMigration.count.should == 1
      end
    end
  end
end
