class SessionsController < ApplicationController

  def info
    user_ip = request.remote_ip
    geolocation = params['position']

    # https://maps.googleapis.com/maps/api/geocode/json?latlng=40.796695899999996,-73.9734577&result_type=street_address|locality|country&key=ENV['GOOGLE_API_KEY']
    # see demo file in controllers folder

    error_message = ""
    error_message += "fb session undefined. " if session[:fb].nil?
    error_message += "se session undefined." if session[:se].nil?

    # either fb or se session is undefined
    if not error_message.empty?
      render json: {error: {message: error_message}}, status: 200

    # fb and se sessions are both defined
    else
      # find user
      current_user = User.find_by(fb_id: session[:fb]["fb_id"])

      confirm_update_se_account = false
      new_user = false

      # create user
      if current_user.nil?
        current_user = User.new(
          fb_id: session[:fb]["fb_id"],
          se_id: session[:se]["se_id"],
          ip_addresses: {user_ip.to_s => [Time.now.to_s]},
          geolocations: [geolocation],
          preferences: {}
        )
        
        if current_user.save
          new_user = true

        # if there are user validation errors
        else 
          return render json: {error: {message: current_user.errors.messages.inspect}}, status: 200
        end

      else
        # if se_id does not match, request confirmation to change 
        confirm_update_se_account = current_user.se_id if session[:se]["se_id"].to_s != current_user.se_id
        new_user = false
      end

      render json: {
        fb_data: session[:fb], 
        se_data: session[:se], 
        geolocation: geolocation,
        new_user: new_user, 
        confirm_update_se_account: confirm_update_se_account
      }, status: 200
    end
  end

  def get_outside_accounts
    # retrieve fb and se user_id's
    fb_response = Unirest.get "https://graph.facebook.com/me",
                  parameters: {
                    access_token: session[:fb]["access_token"]
                  }

    se_response = Unirest.get "https://api.stackexchange.com/2.2/me/associated",
                  parameters: {
                    access_token: session[:se]["access_token"],
                    key: ENV['SE_CLIENT_KEY']
                  }

    if not fb_response.body["error"].nil? or not se_response.body["error_id"].nil?
      return timed_redirect(message: "Oops, something went wrong during logins. Redirecting to welcome page...", location: "t", alert: true) 
    end

    session[:fb]["fb_id"] = fb_response.body["id"]
    session[:se]["se_id"] = se_response.body["items"][0]["account_id"]
    
    redirect_to '/t1'
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
