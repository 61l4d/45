class LoginsController < ApplicationController
  require 'securerandom'

  def init
    if not params[:position].nil?
      geolocation = JSON.parse(params[:position])
      response = Unirest.get "https://maps.googleapis.com/maps/api/geocode/json",
                 parameters: {
                   latlng: geolocation["latitude"].to_s + "," + geolocation["longitude"].to_s,
                   result_type: "street_address|locality|country",
                   key: ENV['GOOGLE_API_KEY']
                 }

      body = response.body
      session[:geolocation] = Geolocation.country_state_locality_from_google_hash(body)
    # see google_geocode_demo file in controllers folder
    end
    # redirect to fb login
    timed_redirect(message: "Redirecting to FB login...", location: "login/fb_oauth", milliseconds: 2000)
  end

  def fb_oauth
    state = SecureRandom.hex

    session[:state] = state

    redirect_uri = ENV['BASE_URL'] + "callbacks/fb"

    redirect_to "https://www.facebook.com/v2.7/dialog/oauth?client_id=#{ENV['FB_CLIENT_ID']}&redirect_uri=#{redirect_uri}&scope=user_friends&state=#{state}"
  end

  def se_oauth
    redirect_uri = ENV['BASE_URL'] + "callbacks/se"

    redirect_to "https://stackexchange.com/oauth?client_id=#{ENV['SE_CLIENT_ID']}&scope=&network_users=true&redirect_uri=#{redirect_uri}&state=#{session[:state]}"
  end
end
