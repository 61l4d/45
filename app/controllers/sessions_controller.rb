class SessionsController < ApplicationController

  def create_account
    # retrieve fb and se user_id's
=begin
    response = Unirest.get "https://graph.facebook.com/v2.7/oauth/access_token",
               parameters: {
                 access_token: session[:fb]
               }

    body = response.body
=end
    raise [session[:fb],CGI::parse(session[:se])].inspect
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
