module SQLite3
  class Blob < String; end

  def self.libversion
    sqlite3_libversion_number()
  end

  SQLITE_VERSION = ::SQLITE_VERSION
  SQLITE_VERSION_NUMBER = ::SQLITE_VERSION_NUMBER
end

SQLITE_STATIC = -> (_) { 0 }
SQLITE_TRANSIENT = -> (_) { -1 }
