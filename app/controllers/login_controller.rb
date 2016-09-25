class LoginController < ApplicationController
  require 'securerandom'

  def index
  end

  def fb_oauth
    state = SecureRandom.hex

    session[:state] = state

    redirect_uri = ENV['BASE_URL'] + "callbacks/fb"

    redirect_to "https://www.facebook.com/v2.7/dialog/oauth?client_id=#{ENV['FB_CLIENT_ID']}&redirect_uri=#{redirect_uri}&state=#{state}"
  end

  def redirect
  end

  def se_oauth
    redirect_uri = ENV['BASE_URL'] + "callbacks/se"

    redirect_to "https://stackexchange.com/oauth?client_id=#{ENV['SE_CLIENT_ID']}&scope=&network_users=true&redirect_uri=#{redirect_uri}&state=#{session[:state]}"
  end
end
