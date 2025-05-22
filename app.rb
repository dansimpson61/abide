require "sinatra"
require "slim"
require_relative "config/db"
require_relative "app/models/reflection"
require_relative "app/controllers/garden_api"
require_relative "app/helpers/sitemap_helper"
require_relative "lib/slim_filters"

helpers SitemapHelper

set :views, File.expand_path("app/views", __dir__)

configure do
  set :protection, except: [:http_origin, :host]
  set :partial_template_engine, :slim
  enable :partial_underscores
  puts "🔧 Sinatra Environment: #{settings.environment}" if settings.development?
end

get "/" do
  #@page_data = fetch_page_data
  slim :index, locals: { reflections: Reflection.all_to_h }
end

get "/dsl" do
  slim :dsl, locals: { reflections: Reflection.all_to_h }
end

# Route for toggle_panel DSL test
get '/dsl/toggle_panel' do
  slim :toggle_panel
end

# Route for sortable DSL test
get '/dsl/sortable' do
  # Pass in a local variable 'reflections' that will be used in the data-binding attribute.
  reflections = "Sample reflection for sortable list"
  slim :sortable, locals: { reflections: reflections }
end

# Route for editable_text DSL test
get '/dsl/editable_text' do
  slim :editable_text
end

# Route for editable_list DSL test
get '/dsl/editable_list' do
  slim :editable_list
end

get '/dsl/test_classy' do
  # For the sortable test we pass a sample value for 'reflections'
  reflections = "Reflection on Garden Path"
  slim :test_dsl_classy, locals: { reflections: reflections }
end

# Master route linking to all DSL test pages
get '/dsl/test' do
  slim :test_dsl
end

get "/test_ui" do
  slim :test_ui
end

get '/slim-filters' do
  # Gather the list of Slim filters
  puts Slim::Filters.constants
  filters = Slim::Filters.constants.map do |const_name|
    Slim::Filters.const_get(const_name)
  end

  # Render the template with the list of filters
  slim :slim_filters, locals: { filters: filters }
end

get "/sitemap" do
  slim :sitemap, locals: { routes: all_routes }
end

helpers do
  def fetch_page_data
    garden_reflections = Reflection.all_to_h
    
    { market: [{ portfolio: [{ id: "market-0", name: "Stocks" },
                             { id: "market-1", name: "Bonds"  },
                             { id: "market-2", name: "Real Estate" }]
              }],
      garden: garden_reflections }
  end
end
