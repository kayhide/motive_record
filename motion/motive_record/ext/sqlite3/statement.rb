module SQLite3
  class Statement
    def initialize(db, sql)
      fail ArgumentError, 'prepare called on a closed database' if db.closed?

      sql.encode!(Encoding::UTF_8) if sql.encoding != Encoding::UTF_8

      @handle = Pointer.new(::Sqlite3_stmt.type)
      tail = Pointer.new('*')
      status = sqlite3_prepare_v2(db.get, sql, sql.bytesize, @handle, tail)
      Exception.check(db.get, status)

      @connection = db
      @remainder = tail.value
      @columns = nil
      @types = nil
      @done = false
    end

    def get
      @handle.value
    end

    def close
      require_open_statement
      status = sqlite3_finalize get
      Exception.check(sqlite3_db_handle(get), status)

      @handle = Pointer.new(::Sqlite3_stmt.type)
      self
    end

    def closed?
      !get
    end

    def step
      require_open_statement
      return nil if done?

      stmt = get
      value = sqlite3_step(stmt);
      length = sqlite3_column_count(stmt);
      list = []

      case value
      when SQLITE_ROW
        (0...length).each do |i|
          case sqlite3_column_type(stmt, i)
          when SQLITE_INTEGER
            list << sqlite3_column_int64(stmt, i)
          when SQLITE_FLOAT
            list << sqlite3_column_double(stmt, i)
          when SQLITE_TEXT
            str = sqlite3_column_text(stmt, i).taint
            list << str
          when SQLITE_BLOB
            str = sqlite3_column_blob(stmt, i).taint
            list << str
          when SQLITE_NULL
            list << nil
          else
            fail RuntimeError, 'bad type'
          end
        end
      when SQLITE_DONE
        @done = true
        nil
      else
        sqlite3_reset(stmt);
        @done = false
        Exception.check(sqlite3_db_handle(stmt), value)
      end
      list
    end

    def bind_param key, value
      require_open_statement

      key = key.to_s if key.is_a? Symbol

      index =
        case key
        when String
          key = ":#{key}" if key[0] != ':'
          sqlite3_bind_paramter_index(get, key)
        else
          key.to_i
        end

      fail Exception, 'no such bind parameter' if index == 0

      status =
        case value
        when Blob
          sqlite3_bind_blob(get, index, value, value.bytesize, SQLITE_TRANSIENT)
        when String
          sqlite3_bind_text(get, index, value, value.bytesize, SQLITE_TRANSIENT)
        when Bignum, Fixnum
          sqlite3_bind_int64(get, index, value)
        when Float
          sqlite3_bind_double(get, index, value)
        when nil
          sqlite3_bind_null(get, index)
        else
          fail RuntimeError, "can't prepare #{value.class}"
        end

      Exception.check(sqlite3_db_handle(get), status)
      self
    end

    def reset!
      require_open_statement

      sqlite3_reset(get)
      @done = false
      self
    end

    def done?
      @done
    end

    def column_count
      require_open_statement
      sqlite3_column_count(get)
    end

    def column_name index
      require_open_statement
      sqlite3_column_name(get, index)
    end

    def column_decltype index
      require_open_statement
      sqlite3_column_decltype(get, index)
    end

    def bind_parameter_count
      require_open_statement
      sqlite3_bind_parameter_count(get)
    end

    private

    def require_open_statement
      fail Exception, 'cannot use a closed statement' if closed?
    end
  end
end
