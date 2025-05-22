require 'sinatra/base'
require "json"
require_relative "../models/reflection"

class GardenAPI < Sinatra::Base
  before do
    content_type :json
    headers "Access-Control-Allow-Origin" => "*"
  
    if request.request_method == "OPTIONS"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH, DELETE"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type"
      halt 200
    end
  
    if ["POST", "PATCH", "DELETE"].include?(request.request_method)
      unless request.content_type == "application/json" || request.env["CONTENT_TYPE"] == "application/json"
        halt 415, { error: "Unsupported media type: Requires application/json" }.to_json
      end
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

  patch "/garden/reflections/reorder" do
    handle_errors do
      request_body = request.body.read
      halt 400, { error: "Missing JSON payload" }.to_json if request_body.strip.empty?

      begin
        data = JSON.parse(request_body)
      rescue JSON::ParserError
        halt 400, { error: "Invalid JSON format" }.to_json
      end

      unless data.is_a?(Hash) && data.key?("reflections") && data["reflections"].is_a?(Array)
        halt 400, { error: "Invalid request structure. Expected { reflections: [...] }" }.to_json
      end

      missing_ids = []
      DB.transaction do
        data["reflections"].each do |wp_data|
          id = wp_data["id"].to_i  # ✅ Ensure ID is an Integer
          reflection = Reflection[id]

          unless reflection
            missing_ids << id
            next  # Don't halt the transaction, collect missing IDs instead
          end

          reflection.update(order: wp_data["order"])
        end
      end

      { success: true }.to_json
    end
  end

  # GET /garden/reflections
  get "/garden/reflections" do
    handle_errors do
      Reflection.order(:order).all.map(&:values).to_json
    end
  end

  # POST /garden/reflections
  post "/garden/reflections" do
    handle_errors do
      data = JSON.parse(request.body.read)
      reflection = Reflection.create(data)
      status 201
      reflection.values.to_json
    end
  end

  # GET /garden/reflections/:id
  get "/garden/reflections/id/:id" do
    handle_errors do
      reflection = Reflection[params[:id]]
      halt 404, { error: "Reflection not found: id:#{params[:id]} could not be gotten" }.to_json unless reflection
      reflection.values.to_json
    end
  end

  # PATCH /garden/reflections/:id
  patch "/garden/reflections/id/:id" do
    handle_errors do
      reflection = Reflection[params[:id]]
      halt 404, { error: "Reflection not found: id:#{params[:id]} could not be patched" }.to_json unless reflection

      data = JSON.parse(request.body.read)
      reflection.update(data.compact) # Ignore `nil` fields
      reflection.values.to_json
    end
  end
  
  # DELETE /garden/reflections/id/:id
  delete "/garden/reflections/:id" do
    handle_errors do
      reflection = Reflection[params[:id]]
      halt 404, { error: "Reflection not found: id:#{params[:id]} could not be deleted" }.to_json unless reflection
      reflection.destroy
      { success: true }.to_json
    end
  end
end
