# :nodoc:
class RootController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin

  def index
    redirect_to '/docs'
  end

  def log_out
    sign_out
    redirect_to root_path
  end

  private

  def set_admin
    @admin = current_admin
  end
end
