class SessionController < ApplicationController

  def create
  end

  def destroy
    session.clear
    render plain: "Logged out successfully."
  end
end
