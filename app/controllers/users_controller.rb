require "rqrcode"
class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[confirm_exit]
  skip_before_action :verify_authenticity_token
  def show
    @user = current_user
    @entered_at = @user.entered_at.strftime("%Y/%m/%d %H:%M:%S") if @user.entered_at.present?
    @exited_at = @user.exited_at.strftime("%Y/%m/%d %H:%M:%S") if @user.exited_at.present?
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

  def enter_page
    @user = current_user
    qr_code = RQRCode::QRCode.new(confirm_enter_user_url(@user))
    @qr_code_svg = qr_code.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    )
  end

  def confirm_enter
    @user = User.find(params[:id])
    ActiveRecord::Base.transaction do
      @user.update(status: :entered, entered_at: Time.zone.now)
    end
    sign_in(@user)
    render status: :ok, json: {
      success: true,
      message: "User entered successfully",
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

  def user_qr
    @user = current_user
    qr_code = RQRCode::QRCode.new({
      id: @user.id,
      name: @user.name,
      total_score: @user.total_score
                                  }.to_json.to_s)
    @qr_code_svg = qr_code.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    )
  end

  # def score
  #   @game_score = GameScore.new(game_score_params)
  #   if @game_score.save
  #     render json: {
  #       success: true,
  #       message: "Game score saved successfully",
  #       game_score: @game_score
  #     }
  #   else
  #     render json: {
  #       success: false,
  #       message: @game_score.errors.full_messages.join(", ")
  #     }
  #   end
  # end

  private
  def game_score_params
    params.require(:game_score).permit(:score, :game_name, :user_id)
  end

end
