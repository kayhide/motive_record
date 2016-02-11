require __ORIGINAL__

module SQLite3
  class Exception
    def self.check db, status
      return if status == SQLITE_OK

      message = sqlite3_errmsg(db)
      case status
      when SQLITE_ERROR
        fail SQLite3::SQLException, message
      when SQLITE_INTERNAL
        fail SQLite3::InternalException, message
      when SQLITE_PERM
        fail SQLite3::PermissionException, message
      when SQLITE_ABORT
        fail SQLite3::AbortException, message
      when SQLITE_BUSY
        fail SQLite3::BusyException, message
      when SQLITE_LOCKED
        fail SQLite3::LockedException, message
      when SQLITE_NOMEM
        fail SQLite3::MemoryException, message
      when SQLITE_READONLY
        fail SQLite3::ReadOnlyException, message
      when SQLITE_INTERRUPT
        fail SQLite3::InterruptException, message
      when SQLITE_IOERR
        fail SQLite3::IOException, message
      when SQLITE_CORRUPT
        fail SQLite3::CorruptException, message
      when SQLITE_NOTFOUND
        fail SQLite3::NotFoundException, message
      when SQLITE_FULL
        fail SQLite3::FullException, message
      when SQLITE_CANTOPEN
        fail SQLite3::CantOpenException, message
      when SQLITE_PROTOCOL
        fail SQLite3::ProtocolException, message
      when SQLITE_EMPTY
        fail SQLite3::EmptyException, message
      when SQLITE_SCHEMA
        fail SQLite3::SchemaChangedException, message
      when SQLITE_TOOBIG
        fail SQLite3::TooBigException, message
      when SQLITE_CONSTRAINT
        fail SQLite3::ConstraintException, message
      when SQLITE_MISMATCH
        fail SQLite3::MismatchException, message
      when SQLITE_MISUSE
        fail SQLite3::MisuseException, message
      when SQLITE_NOLFS
        fail SQLite3::UnsupportedException, message
      when SQLITE_AUTH
        fail SQLite3::AuthorizationException, message
      when SQLITE_FORMAT
        fail SQLite3::FormatException, message
      when SQLITE_RANGE
        fail SQLite3::RangeException, message
      when SQLITE_NOTADB
        fail SQLite3::NotADatabaseException, message
      end

      fail RuntimeError, message
    end
  end
end
