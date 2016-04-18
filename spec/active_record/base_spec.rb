describe ActiveRecord::Base do
  suppress_migration_output
  use_database :memory
  use_migration :books

  describe '.create' do
    it 'creates' do
      Book.count.should == 0
      Book.create title: 'Book 1'
      Book.count.should == 1
      Book.create! title: 'Book 2'
      Book.count.should == 2
    end
  end

  describe '.first/last' do
    it 'returns nil if no record exists' do
      Book.first.should == nil
      Book.last.should == nil
    end

    it 'returns first/last record' do
      books = Book.create(3.times.map { |i| { title: "Book #{i}" } })
      Book.first.should == books.first
      Book.last.should == books.last
    end

    it 'returns first/last multiple records when count specified' do
      books = Book.create(3.times.map { |i| { title: "Book #{i}" } })
      Book.first(2).should == books.first(2)
      Book.last(2).should == books.last(2)
    end
  end

  describe '.find' do
    it 'returns model object' do
      book = Book.create id: 123, title: 'Book 123'
      Book.find(123).should == book
    end

    it 'fails if not found' do
      lambda {
        Book.find(123)
      }.should.raise ActiveRecord::RecordNotFound
    end
  end

  describe '.all' do
    it 'returns relation for all records' do
      books = Book.create(3.times.map { |i| { title: "Book #{i}" } })
      arel = Book.all
      arel.should.be.kind_of ActiveRecord::Relation
      arel.to_a.should == books
    end
  end

  describe '.where' do
    it 'returns relation for matched records' do
      books = Book.create(2.times.map { |i| { title: 'This' } })
      Book.create(title: 'That')
      arel = Book.where(title: 'This')
      arel.should.be.kind_of ActiveRecord::Relation
      arel.to_a.should == books
    end
  end

  describe '.order' do
    it 'returns relation for ordered records' do
      books = [
        Book.create(title: 'Book 3'),
        Book.create(title: 'Book 1'),
        Book.create(title: 'Book 2')
      ]
      arel = Book.order(:title)
      arel.should.be.kind_of ActiveRecord::Relation
      arel.to_a.should == books.sort_by(&:title)
    end

    it 'returns relation for reverse ordered records when desc specified' do
      books = [
        Book.create(title: 'Book 3'),
        Book.create(title: 'Book 1'),
        Book.create(title: 'Book 2')
      ]
      arel = Book.order(title: :desc)
      arel.should.be.kind_of ActiveRecord::Relation
      arel.to_a.should == books.sort_by(&:title).reverse
    end
  end

  describe '.limit' do
    it 'returns relation for limited records' do
      books = Book.create(3.times.map { |i| { title: "Book #{i}" } })
      arel = Book.limit(2)
      arel.should.be.kind_of ActiveRecord::Relation
      arel.to_a.should == books.take(2)
    end
  end

  describe '.offset' do
    it 'returns relation for offset records' do
      books = Book.create(3.times.map { |i| { title: "Book #{i}" } })
      arel = Book.offset(1)
      arel.should.be.kind_of ActiveRecord::Relation
      arel.to_a.should == books.drop(1)
    end
  end

  describe '#save' do
    it 'creates' do
      book = Book.new title: 'Book'
      book.save
      Book.last.should == book
    end

    it 'updates' do
      book = Book.create title: 'Book'
      book.title = 'New Title'
      book.save
      Book.last.title.should == 'New Title'
    end
  end

  describe '#destroy' do
    it 'deletes' do
      book = Book.create title: 'Book'
      Book.last.destroy.should == book
      Book.count.should == 0
    end
  end
end
