Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root

	root to: 'home#parked'


  # home

  get 't', to: "home#index"

  get 'proxy', to: "home#proxy"

  get 'fb_proxy', to: "home#fb_proxy"


  # sessions

  post 'login', to: 'sessions#create'

  get 'logout', to: 'sessions#destroy'
end
