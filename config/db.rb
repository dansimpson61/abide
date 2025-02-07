require "sequel"
require "sqlite3"

# Only print logs if running in a development environment
DB = Sequel.connect("sqlite://db/development.sqlite3")

begin
  DB.test_connection
  puts "✅ Database Connection Established."
rescue => e
  puts "❌ Database Connection Failed: #{e.message}"
  exit 1
end
