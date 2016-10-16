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

  get 'login/init', to: 'logins#init'

  get 'login/fb_oauth', to: 'logins#fb_oauth'

  get 'login/se_oauth', to: 'logins#se_oauth'


  # callbacks
  
  get 'callbacks/fb', to: 'callbacks#fb'

  get 'callbacks/se', to: 'callbacks#se'


  # sessions
	
	post 'sessions/info', to: 'sessions#info'

  get 'login', to: 'sessions#get_outside_accounts'

  get 'logout', to: 'sessions#destroy'


  # interactions

  post 'update', to: 'interactions#update'
end
