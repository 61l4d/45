class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng

  # http://stackoverflow.com/questions/14734243/rails-csrf-protection-angular-js-protect-from-forgery-makes-me-to-log-out-on
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end


  # http://stackoverflow.com/questions/25841377/rescue-from-actioncontrollerroutingerror-in-rails4
  # You want to get exceptions in development, but not in production.
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: -> { render_404  }
		rescue_from ActionController::UnknownController, with: -> { render_404  }
		rescue_from ActiveRecord::RecordNotFound, with: -> { render_404  }
  end

	protected

  def timed_redirect(message: "", location: "")
    redirect_to ENV['BASE_URL'] + "redirect.html?m=#{URI::encode(message.reverse)}&u=#{URI::encode(location.reverse)}"
  end

  def render_404
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  # In Rails 4.2 and above
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end
end
