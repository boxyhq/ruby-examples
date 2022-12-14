class OmniauthController < ApplicationController
  skip_before_action :require_login, raise: false

    def callback
      user_info = request.env['omniauth.auth']
      session[:userinfo] = user_info['extra']['raw_info']
      redirect_to omniauth_profile_path,  notice: "Logged in using omniauth!"
    end

    def logout
      reset_session
      redirect_to root_path,  notice: "Logged out from Omniauth!"
    end
  end