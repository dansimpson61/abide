require "sequel"
require "sqlite3"

DB = Sequel.connect("sqlite://db/abide.sqlite3")

begin
  DB.test_connection
  puts "✅ Database Connection Established."
rescue => e
  puts "❌ Database Connection Failed: #{e.message}"
  exit 1
end

Sequel::Model.db = DB
