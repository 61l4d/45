class CallbacksController < ApplicationController
  def fb
    # state mismatch
    if session[:state].nil? or params[:state] != session[:state]
      raise "State mismatch. Session state: " + session[:state] 
          + " Params: " + params.inspect
    end

    # error, such as user denies permission
    raise params.inspect if params[:error]
  
    # code seems to be missing
    if params[:code].nil?
      raise "Code seems to be missing. Params: " + params.inspect

    # get access token
    else
      redirect_uri = ENV['BASE_URL'] + "callbacks/fb"

      response = Unirest.get "https://graph.facebook.com/v2.7/oauth/access_token",
                 parameters: {
                   client_id: ENV['FB_CLIENT_ID'],
                   redirect_uri: redirect_uri,
                   client_secret: ENV['FB_CLIENT_SECRET'],
                   code: params[:code]
                 }

      body = response.body
      
      # access token missing
      raise "Facebook access token seems to be missing. Response: " + response.inspect if not body['access_token']

      session[:fb] = body
     
      # redirect to se login
      redirect_to ENV['BASE_URL'] + "login/se"
    end
  end

  def se
    raise params.inspect
  end
end
