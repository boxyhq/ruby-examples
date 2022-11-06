class SessionsController < ApplicationController
    def callback
      user_info = request.env['omniauth.auth']
      session[:userinfo] = request.env['omniauth.auth']['extra']['raw_info']

      redirect_to profile_path, notice: "Logged in using omniauth!"
    end
  end