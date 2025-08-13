class AirportsController < ApplicationController
  def show
  airport_key = params[:key] # e.g. "ipoh-airport"
  json_path = Rails.root.join("public", "airport-routes.json")
  airports_json = JSON.parse(File.read(json_path))
  @airport_data = airports_json[airport_key]
  end
end
