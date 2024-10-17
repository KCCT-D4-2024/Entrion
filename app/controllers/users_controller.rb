require "rqrcode"
class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
  end

  def enter
    ActiveRecord::Base.transaction do
      current_user.update(status: :entered)
    end
    redirect_to users_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
  ensure
  end

  def edit
  end
end
