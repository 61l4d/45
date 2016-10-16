class InteractionsController < ApplicationController
  def update
    command = interaction_params[:command]
    paramaters = interaction_params[:parameters]

    case command
    when 'update se account'
      if current_user.nil?
        render json: {error: {message: "Current user is undefined. Please log in again."}}
      else
        if not session[:se].nil?
          if current_user.update(se_id: session[:se]["se_id"])
            render json: {message: "SE account successfully updated to " + session[:se]["se_id"].to_s + "."}

          # could not update user
          else
            render json: {message: "Could not update SE account. " + current_user.errors.messages.inspect}
          end

        # se session undefined
        else
          render json: {error: {message: "SE session is undefined."}}
        end
      end
    end
  end

  private

  def interaction_params
    params.require(:interaction).permit(:command,parameters:[])
  end
end
