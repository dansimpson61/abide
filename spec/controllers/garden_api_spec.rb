require_relative "../spec_helper"
require "rack/test"

RSpec.describe GardenAPI do
  include Rack::Test::Methods

  def app
    GardenAPI
  end

  before do
    @reflection = Reflection.create(
      name: "Test Reflection",
      type: "Task",
      status: "todo"
    )
  end

  describe "GET /garden/reflections" do
    it "returns all reflections in order" do
      get "/garden/reflections"
      expect(last_response.status).to eq(200)
      data = JSON.parse(last_response.body)
      expect(data.first["name"]).to eq("Test Reflection")
    end
  end

  describe "PATCH /garden/reflections/reorder" do
    it "updates reflection order" do
      patch "/garden/reflections/reorder", 
        JSON.generate({ reflections: [{ id: @reflection.id, order: 5 }] }),
        { "CONTENT_TYPE" => "application/json" }

      expect(last_response.status).to eq(200)
      expect(@reflection.reload.order).to eq(5)
    end
  end
end