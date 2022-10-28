class LoginsController < ApplicationController
  skip_before_action :require_login

  def index; end

  def destroy
    logout
    redirect_to(root_path, notice: 'Logged out!')
  end
end
