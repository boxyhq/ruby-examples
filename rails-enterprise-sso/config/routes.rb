Rails.application.routes.draw do
  root 'home#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'sso', to: 'logins#index', as: :login
  post 'sso', to: 'sorcery#oauth'

  delete 'logout' => 'logins#destroy', as: :logout

  resource :oauth do
    get :callback, to: 'sorcery#callback', on: :collection
  end

  get 'profile', to: 'profiles#index', as: :profile

  get '/setup/sso', to: 'ssos#index', as: :setup_sso
  post '/setup/sso', to: 'ssos#save_connection', as: :save_connection

  # OmniAuth
  get 'auth/boxyhqsso/callback', to: 'omniauth#callback'
  get 'omniauth/profile', to: 'omniauth_profiles#show', as: :omniauth_profile
  delete 'omniauth/logout' => 'omniauth#logout', as: :omniauth_logout
end
