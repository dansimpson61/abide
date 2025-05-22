require "sequel"
require "sqlite3"

DB_PATH = "db/abide.db"  # ✅ Force a single shared database

DB = Sequel.connect("sqlite://#{DB_PATH}")

begin
  DB.test_connection
  puts "✅ Database Connection Established: Using #{DB_PATH}"
rescue => e
  puts "❌ Database Connection Failed: #{e.message}"
  exit 1
end

Sequel::Model.db = DB
