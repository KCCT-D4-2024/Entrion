require "rqrcode"
class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[confirm_exit]
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
    redirect_to root_path
  ensure
  end

  def exit
    @user = current_user
    qr_code = RQRCode::QRCode.new(confirm_exit_user_url(@user))
    @qr_code_svg = qr_code.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    )
  end

  def confirm_exit
    @user = User.find(params[:id])
    ActiveRecord::Base.transaction do
      @user.update(status: :exited, exited_at: Time.zone.now)
    end
    sign_out(@user)
    render status: :ok, json: {
      success: true,
      message: "User exited successfully",
      user: @user
    }
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
    render status: :not_acceptable, json: {
      success: false,
      message: e.message
    }
  ensure
  end

  def edit
  end

  private
end
