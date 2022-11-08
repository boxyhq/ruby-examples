class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :require_login, except: [:not_authenticated]

  def omniauth_user
    @user = session[:userinfo]
  end

  helper_method :omniauth_user

  protected

  def not_authenticated # only for sorcery
    redirect_to login_path, alert: '⚠️ Please login using sorcery first.'
  end
end
