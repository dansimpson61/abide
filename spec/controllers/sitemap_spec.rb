require_relative "../spec_helper"
require "rack/test"

RSpec.describe "Sitemap" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "GET /sitemap" do
    it "returns sitemap with correct format" do
      get "/sitemap"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<title>Sitemap</title>")
      expect(last_response.body).to include("Available Routes")
    end
  end
end
