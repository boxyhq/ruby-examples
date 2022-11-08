class SorceryController < ApplicationController
  skip_before_action :require_login, raise: false

  def index; end

  def oauth
    # tenant = params[:teamId]
    login_at('boxyhqsaml', state: SecureRandom.hex(16))
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def callback
    provider = 'boxyhqsaml'
    if @user = login_from(provider)
      redirect_to profile_path, notice: "Logged in from #{provider.titleize}!"
    else
      begin
        @user = create_from(provider)

        # @user.activate!
        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to profile_path, notice: "Logged in from #{provider.titleize}!"
      rescue
        redirect_to root_path, alert: "Failed to login from #{provider.titleize}!"
      end
    end
  rescue ::OAuth2::Error => e
    Rails.logger.error e
    Rails.logger.error e.code
    Rails.logger.error e.description
    Rails.logger.error e.message
    Rails.logger.error e.backtrace
  end
end
