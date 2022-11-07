class OmniauthProfilesController < ApplicationController
    skip_before_action :require_login, raise: false
  
    def show
      @is_omniauth = true
      @current_user = session[:userinfo]
      render "profiles/index"
    end
  end
  