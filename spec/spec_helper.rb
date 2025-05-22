ENV['RACK_ENV'] = 'test'

require_relative "../app"
require "capybara/rspec"
require "database_cleaner/sequel"

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation  # ✅ Use truncation instead of transactions
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
