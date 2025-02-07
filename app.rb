require "sinatra"
require "slim"
require_relative "config/db"
require_relative "app/models/reflection"

get "/" do
  reflections = Reflection.order(:order).all

  # Structure data for rendering
  @page_data = {
    market: [{ portfolio: ["Stocks", "Bonds", "Real Estate"] }],  # Placeholder for now
    garden: reflections.group_by(&:type) # Group reflections by type for structured display
  }

  slim :index
end
