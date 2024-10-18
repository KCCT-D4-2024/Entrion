require "rqrcode"
class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
  end

  def enter
    @user = current_user
    ActiveRecord::Base.transaction do
      @user.update(status: :entered, entered_at: Time.zone.now)
    end
    redirect_to users_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
  ensure
  end

  def edit
  end
end
