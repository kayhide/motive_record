describe MotiveRecord do
  it 'has a version number' do
    MotiveRecord::VERSION.should.not == nil
  end

  it 'works with on memory sqlite3' do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    # dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate')
    # migs = ActiveRecord::Migrator.migrations dir
    # migs.first.migrate :up
    ActiveRecord::Schema.define(version: 1) do
      create_table :books do |t|
        t.string :title
        t.timestamps null: false
      end
    end

    class Book < ActiveRecord::Base; end
    Book.inspect.should.match(/Book.*id: integer/)
  end
end
