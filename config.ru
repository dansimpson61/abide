require './app' 
require './app/controllers/garden_api'

map '/' do
  run Sinatra::Application
end

map '/api' do
  run GardenAPI
end
