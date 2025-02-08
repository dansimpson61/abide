require 'sinatra/base'
require "json"
require_relative "../models/reflection"

class GardenAPI < Sinatra::Base
  before do
    content_type :json
    headers "Access-Control-Allow-Origin" => "*"
  
    if ["POST", "PATCH", "DELETE"].include?(request.request_method)
      halt 415, { error: "Unsupported media type: Requires application/json" }.to_json unless request.content_type == "application/json"
    end
  end

  helpers do
    def handle_errors
      yield
    rescue JSON::ParserError
      halt 400, { error: "Invalid JSON format" }.to_json
    rescue Sequel::ValidationFailed => e
      halt 422, { errors: e.errors.full_messages }.to_json
    rescue Sequel::Error => e
      halt 500, { error: "Database error: #{e.message}" }.to_json
    rescue => e
      halt 500, { error: "Unexpected error: #{e.message}" }.to_json
    end
  end

  configure do
    set :show_exceptions, false
  end

  ##########################################
  # For test and development only
  delete "/api/garden/reflections/delete_all" do
    halt 403, { error: "Forbidden in production" }.to_json if settings.production?
    handle_errors do
      Reflection.dataset.delete 
      { success: true }.to_json
    end
  end
  ##########################################

  patch "/api/garden/reflections/reorder" do
    handle_errors do
      data = JSON.parse(request.body.read)
      
      DB.transaction do
        data["reflections"].each do |wp_data|
          wp = Reflection[wp_data["id"]]
          halt(404, { error: "Reflection #{wp_data["id"]} not found" }.to_json) unless wp
          wp.update(order: wp_data["order"])
        end
      end
      
      { success: true }.to_json
    end
  end

  # GET /api/garden/reflections
  get "/api/garden/reflections" do
    handle_errors do
      Reflection.order(:order).all.map(&:values).to_json
    end
  end

  # POST /api/garden/reflections
  post "/api/garden/reflections" do
    handle_errors do
      data = JSON.parse(request.body.read)
      reflection = Reflection.create(data)
      status 201
      reflection.values.to_json
    end
  end

  # GET /api/garden/reflections/:id
  get "/api/garden/reflections/:id" do
    handle_errors do
      reflection = Reflection[params[:id]]
      halt 404, { error: "Reflection not found" }.to_json unless reflection
      reflection.values.to_json
    end
  end

  # PATCH /api/garden/reflections/:id
  patch "/api/garden/reflections/:id" do
    handle_errors do
      reflection = Reflection[params[:id]]
      halt 404, { error: "Reflection not found" }.to_json unless reflection

      data = JSON.parse(request.body.read)
      reflection.update(data.compact) # Ignore `nil` fields
      reflection.values.to_json
    end
  end
  
  # DELETE /api/garden/reflections/:id
  delete "/api/garden/reflections/:id" do
    handle_errors do
      reflection = Reflection[params[:id]]
      halt 404, { error: "Reflection not found" }.to_json unless reflection
      reflection.destroy
      { success: true }.to_json
    end
  end
end
