Rails.application.routes.draw do
  root 'home#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'sso', to: 'logins#index'
  post 'sso', to: 'oauths#oauth'
  resource :oauth do
    get :callback, to: 'oauths#callback', on: :collection
  end

  get 'profile', to: 'profiles#index', as: 'profile'
end
