class InteractionsController < ApplicationController
  def update
    render json: message_params.inspect
  end

  private

  def interaction_params
    params.require(:interaction).permit(:message)
  end

  def message_params
    interaction_params[:message]
  end
end
