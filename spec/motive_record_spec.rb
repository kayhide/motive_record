describe MotiveRecord do
  it 'has a version number' do
    MotiveRecord::VERSION.should.not == nil
  end

  it 'migrates with migration files' do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate')
    migs = ActiveRecord::Migrator.migrations dir
    migs.first.migrate :up

    Book.inspect.should.match(/Book.*id: integer/)
  end

  it 'works with file database' do
    db_name = 'test.sqlite'
    support_dir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true).first
    db_file = File.expand_path(db_name, support_dir)
    File.delete db_file if File.exist? db_file
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db_name)
    dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate')
    migs = ActiveRecord::Migrator.migrations dir
    migs.first.migrate :up

    Book.inspect.should.match(/Book.*id: integer/)
  end

  describe 'Base' do
    before do
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
      ActiveRecord::Schema.define(version: 1) do
        create_table :books do |t|
          t.string :title
          t.timestamps null: false
        end
      end
    end

    it 'creates' do
      Book.count.should == 0
      Book.create
      Book.count.should == 1
      Book.create!
      Book.count.should == 2
    end

    it 'first/last' do
      Book.first.should == nil
      Book.last.should == nil
    end
  end
end

