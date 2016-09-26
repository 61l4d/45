class SessionsController < ApplicationController

  def create_account
    # retrieve fb and se user_id's
    raise [session[:fb],session[:se]].inspect
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
