require "sinatra"
require "slim"
require_relative "config/db"
require_relative "app/models/reflection"
require_relative "app/controllers/garden_api"

set :views, File.expand_path("app/views", __dir__)

helpers do
  def fetch_page_data
    {
      market: [{ portfolio: ["Stocks", "Bonds", "Real Estate"] }],
      garden: Reflection.dataset_to_h  # ✅ Use the dataset method
    }
  end
end

get "/" do
  @page_data = fetch_page_data
  slim :index
end
