module SQLite3
  class Database
    def initialize file, options = {}
      mode =
        if options[:readonly]
          SQLITE_OPEN_READONLY
        else
          SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        end

      @handle = Pointer.new(::Sqlite3.type)
      status = sqlite3_open_v2(file, @handle, mode, nil)
      Exception.check get, status

      @tracefunc = nil
      @authorizer = nil
      @encoding = nil
      @busy_handler = nil
      @collations = {}
      @functions = {}
      @results_as_hash = options[:results_as_hash]
      @type_translation = options[:type_translation]
      @readonly = mode == SQLITE_OPEN_READONLY
    end

    def get
      @handle.value
    end

    def close
      db = get
      status = sqlite3_close get
      Exception.check db, status

      @handle = Pointer.new(::Sqlite3.type)
      self
    end

    def closed?
      !get
    end

    def encoding
      unless @encoding
        proc = ->(_, _, str_p, _) {
          @encoding = Encoding.find str_p.value
          0
        }
        sqlite3_exec(get, "PRAGMA encoding", proc, nil, nil)
      end
      @encoding
    end

    def changes
      sqlite3_changes(get)
    end

    def last_insert_row_id
      sqlite3_last_insert_rowid(get)
    end

    def busy_timeout= timeout
      status = sqlite3_busy_timeout get, timeout
      Exception.check get, status

      self
    end
  end
end
