describe ActiveRecord::Associations do
  use_database

  describe '.has_many' do
    before do
      @book = Book.create title: 'Book 1'
    end

    describe 'reader' do
      it 'creates' do
        @book.chapters.count.should == 0
        @book.chapters.create title: 'Chapter 1'
        @book.chapters.count.should == 1
        @book.chapters.create! title: 'Chapter 2'
        @book.chapters.count.should == 2
      end

      describe '#first/last' do
        it 'returns nil if no record exists' do
          @book.chapters.first.should == nil
          @book.chapters.last.should == nil
        end

        it 'returns first/last record' do
          chapters = 3.times.map do |i|
            Chapter.create book_id: @book.id, title: "Chapter #{i}"
          end
          @book.chapters.first.should == chapters.first
          @book.chapters.last.should == chapters.last
        end

        it 'returns first/last multiple records when count specified' do
          chapters = 3.times.map do |i|
            Chapter.create book_id: @book.id, title: "Chapter #{i}"
          end
          @book.chapters.first(2).should == chapters.first(2)
          @book.chapters.last(2).should == chapters.last(2)
        end
      end

      describe '.find' do
        it 'returns model object' do
          chapter = @book.chapters.create id: 123, title: 'Chapter 123'
          @book.chapters.find(123).should == chapter
        end

        it 'fails if not found' do
          lambda {
            @book.chapters.find(123)
          }.should.raise ActiveRecord::RecordNotFound
        end
      end

      describe '.all' do
        it 'returns relation for all records' do
          chapters = 3.times.map do |i|
            Chapter.create book_id: @book.id, title: "Chapter #{i}"
          end
          arel = @book.chapters.all
          arel.should.be.kind_of ActiveRecord::Relation
          arel.to_a.should == chapters
        end
      end
    end

    describe 'writer' do
      it 'creates' do
        @book.chapters = 3.times.map do |i|
          Chapter.new title: "Chapter #{i}"
        end
        Chapter.count.should == 3
        Chapter.pluck(:book_id).should == [@book.id] * 3
      end
    end
  end

  describe '.belongs_to' do
    before do
      @book = Book.create title: 'Book 1'
      @chapter = @book.chapters.create title: 'Chapter 1'
    end

    describe 'reader' do
      it 'returns model object' do
        @chapter.book.should == @book
      end
    end

    describe 'writer' do
      it 'replaces reference id' do
        new_book = Book.create title: 'New Book'
        @chapter.book = new_book
        @chapter.book_id.should == new_book.id
      end
    end

    describe 'initializer' do
      it 'accepts model object' do
        chapter = Chapter.new book: @book
        chapter.book_id.should == @book.id
      end
    end

    describe 'query' do
      it 'accepts model object' do
        Chapter.where(book: @book).should == [@chapter]
      end

      it 'accepts model id' do
        Chapter.where(book: @book.id).should == [@chapter]
      end

      it 'accepts array of model objects and ids' do
        new_book = Book.create title: 'New Book'
        new_chapter = new_book.chapters.create title: 'New Chpater'
        Chapter.where(book: [@book, new_book.id]).sort.
          should == [@chapter, new_chapter]
      end
    end
  end
end
