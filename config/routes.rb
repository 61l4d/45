Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root

	root to: 'home#parked'


  # home

  get 't', to: "login#fb"


  # logins

  get 'login/fb', to: 'login#fb'

  get 'login/se', to: 'login#se'


  # callbacks
  
  get 'callbacks/fb', to: 'callbacks#fb'

  get 'callbacks/se', to: 'callbacks#se'


  # sessions

  post 'login', to: 'sessions#create'

  get 'logout', to: 'sessions#destroy'
end
