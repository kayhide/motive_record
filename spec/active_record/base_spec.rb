describe ActiveRecord::Base do
  suppress_migration_output
  use_database :memory

  before do
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

  describe '.first/last' do
    it 'returns nil if no record exists' do
      Book.first.should == nil
      Book.last.should == nil
    end

    it 'returns first/last model object' do
      books = Book.create(3.times.map { |i| { title: "Book #{i}" } })
      Book.first.should == books.first
      Book.last.should == books.last
    end
  end

  describe '.find' do
    it 'returns model object' do
      book = Book.create id: 123
      Book.find(123).should == book
    end

    it 'fails if not found' do
      lambda {
        Book.find(123)
      }.should.raise ActiveRecord::RecordNotFound
    end
  end
end
