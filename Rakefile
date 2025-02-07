require "rake"
require "sequel"
require "sqlite3"
require_relative "config/db"

namespace :db do
  desc "Run all migrations"
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, "db/migrations")
    puts "✅ Migrations complete."
  end

  desc "Rollback the last migration"
  task :rollback do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, "db/migrations", target: (DB[:schema_migrations].count - 1))
    puts "🔄 Rolled back the last migration."
  end

  desc "Reset the database (drop & recreate)"
  task :reset do
    puts "⚠️  Resetting database..."
    File.delete("db/development.sqlite3") if File.exist?("db/development.sqlite3")
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    puts "✅ Database reset complete."
  end

  desc "Seed the database with initial data"
  task :seed do
    require_relative "db/seeds"
    puts "🌱 Database seeded."
  end
end
