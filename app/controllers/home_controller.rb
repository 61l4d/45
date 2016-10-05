class HomeController < ApplicationController
  def index
    return redirect_to '' if session[:fb].nil? or session[:se].nil?
    @fb_data = session[:fb].to_json
    @se_data = session[:se].to_json
  end

  def welcome
  end

  def parked
  end
end
