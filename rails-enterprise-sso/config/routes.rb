Rails.application.routes.draw do
  root 'home#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'sso', to: 'logins#index', as: 'login'
  post 'sso', to: 'oauths#oauth'

  delete 'logout' => 'logins#destroy', as: :logout

  resource :oauth do
    get :callback, to: 'oauths#callback', on: :collection
  end

  get 'profile', to: 'profiles#index', as: 'profile'

  get '/setup/sso', to: 'ssos#index', as: 'setup_sso'
end
