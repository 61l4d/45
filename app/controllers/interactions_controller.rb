class InteractionsController < ApplicationController
  def update

    # move this functionality to model?

    return render json: {error: {message: "Current user is undefined. Please log in again."}} if current_user.nil?

    command = interaction_params[:command]
    parameters = interaction_params[:parameters]

    case command

    # update se account command
    when 'update se account'
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
    # end update se account command

    # update my location command
    when 'update my location'
      location_string = "";

      new_region = Region.find_by(name: parameters[0])
      location_string += new_region.name if not new_region.nil?

      if not new_region.nil?
        new_country = Country.find_by(name: parameters[1])
        location_string += ", #{new_country.name}" if not new_country.nil?
      end

      if not new_country.nil?
        new_division = Division.find_by(name: parameters[2])
        location_string += ", #{new_division.name}" if not new_division.nil?
      end

      current_user.update(region: new_region, country: new_country, division: new_division)
      render json: {location_string: location_string}, status: 200
    end # end case
  end

  private

  def interaction_params
    params.require(:interaction).permit(:command,parameters:[])
  end
end
