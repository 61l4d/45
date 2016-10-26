class SessionsController < ApplicationController

  def info
    user_ip = request.remote_ip

    error_message = ""
    error_message += "fb session undefined. " if session[:fb].nil?
    error_message += "se session undefined." if session[:se].nil?

    # either fb or se session is undefined
    if not error_message.empty?
      render json: {error: {message: error_message}}, status: 200

    # fb and se sessions are both defined
    else
      confirm_update_se_account = false
      new_user_created = false
      my_location = false

      # create user
      if current_user.nil?
        new_user = User.new(
          fb_id: session[:fb]["fb_id"],
          se_id: session[:se]["se_id"],
          ip_addresses: user_ip,
          preferences: {}
        )
        
        new_user.geolocations = session[:geolocation] if not session[:geolocation].nil?

        if new_user.save
          new_user_created = true
          friends_updated = new_user.update_connections(new_user.get_friends(session[:fb]["access_token"]))

        # if there are user validation errors
        else 
          return render json: {error: {message: new_user.errors.messages.inspect}}, status: 200
        end

      # current_user is defined
      else
        current_user.update(ip_addresses: user_ip)
        current_user.update(geolocations: session[:geolocation]) if not session[:geolocation].nil?

        # if se_id does not match, request confirmation to change 
        confirm_update_se_account = current_user.se_id if session[:se]["se_id"].to_s != current_user.se_id

        # retrieve location set by user
        my_location = {
          region: current_user.region.name, 
          country: current_user.country.nil? ? nil : current_user.country.name, 
          division: current_user.division.nil? ? nil : current_user.division.name
        } if not current_user.region.nil?

        # users object
        friends_updated = current_user.update_connections(current_user.get_friends(session[:fb]["access_token"]))
      end

      render json: {
        session: {
          fb_data: session[:fb], 
          se_data: session[:se], 
          geolocation: session[:geolocation],
          my_location: my_location,
          new_user_created: new_user_created, 
          confirm_update_se_account: confirm_update_se_account
        },
        friends_updated: friends_updated
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
		session[:fb]["name"] = fb_response.body["name"]
    session[:se]["se_id"] = se_response.body["items"][0]["account_id"] # se_response.body["items"] might be missing if no accounts exist except the stackexchange account itself.
    
    redirect_to '/t1'
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
