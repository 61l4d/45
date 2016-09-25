class SessionsController < ApplicationController

  def create
    raise session[:fb].inspect 
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
