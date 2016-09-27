class SessionsController < ApplicationController

  def create_account
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

    fb_id = fb_response.body["id"]
    se_id = se_response.body["items"][0]["account_id"]
    
    raise [fb_id,se_id].inspect
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
