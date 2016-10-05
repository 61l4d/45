Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	# http://stackoverflow.com/questions/25841377/rescue-from-actioncontrollerroutingerror-in-rails4
	unless Rails.application.config.consider_all_requests_local
    # having created corresponding controller and action
    get '*not_found', to: 'errors#error_404'
  end

  # root

	root to: 'home#parked'


  # home

  get 't', to: "home#welcome"
	get 't1', to: "home#index"


  # logins

  get 'login/init', to: 'login#init'

  get 'login/fb_oauth', to: 'login#fb_oauth'

  get 'login/se_oauth', to: 'login#se_oauth'


  # callbacks
  
  get 'callbacks/fb', to: 'callbacks#fb'

  get 'callbacks/se', to: 'callbacks#se'


  # sessions

  get 'login', to: 'sessions#create_account'

  get 'logout', to: 'sessions#destroy'
end
