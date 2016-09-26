class CallbacksController < ApplicationController

  # FB login

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
      timed_redirect(message: "Redirecting to SE login...", location: "login/se_oauth")
    end
  end


  # SE login
  
  def se
    # state mismatch
    if session[:state].nil? or params[:state] != session[:state]
      raise "State mismatch. Session state: " + session[:state] 
          + " Params: " + params.inspect
    end

    # error, such as user denies permission
    raise params.inspect if not params[:error].nil? or not params[:error_id].nil?
  
    # code seems to be missing
    if params[:code].nil?
      raise "Code seems to be missing. Params: " + params.inspect

    # get access token
    else
      redirect_uri = ENV['BASE_URL'] + "callbacks/se"

      response = Unirest.post "https://stackexchange.com/oauth/access_token",
                 parameters: {
                   client_id: ENV['SE_CLIENT_ID'],
                   redirect_uri: redirect_uri,
                   client_secret: ENV['SE_CLIENT_SECRET'],
                   code: params[:code]
                 }

      body = response.body

      # access token missing
      raise "Stack Exchange access token seems to be missing. Response: " + response.inspect if not body['access_token']

      session[:se] = body
     
      # redirect to index page
      redirect_to ENV['BASE_URL'] + "login"
    end
  end
end
