class OmniauthProfilesController < ApplicationController
    skip_before_action :require_login, raise: false
    include OmniauthSecured
  
    def show
      @user = session[:userinfo]
    end
  end
  