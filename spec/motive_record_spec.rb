describe MotiveRecord do
  it 'has a version number' do
    MotiveRecord::VERSION.should.not == nil
  end

  it 'works with on memory sqlite3' do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    ActiveRecord::Schema.define(version: 1) do
      create_table :books do |t|
        t.string :title
        t.timestamps null: false
      end
    end

    Book.inspect.should.match(/Book.*id: integer/)
    Book.last.should == nil
    Book.count.should == 0
  end

  it 'migrates' do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate')
    migs = ActiveRecord::Migrator.migrations dir
    migs.first.migrate :up

    Book.inspect.should.match(/Book.*id: integer/)
  end

  it '' do
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
end

