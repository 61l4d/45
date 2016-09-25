class SessionsController < ApplicationController

  def create
    raise session[:se] 
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
