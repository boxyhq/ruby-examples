module OmniauthSecured
    extend ActiveSupport::Concern
  
    included do
      before_action :logged_in_using_omniauth?
    end
  
    def logged_in_using_omniauth?
      redirect_to login_path, notice: "⚠️ Please login using omniauth" unless session[:userinfo].present?
    end
end