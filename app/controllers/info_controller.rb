class InfoController < ApplicationController
  def admin
    @users = User.all
    @entered_count = User.entered.count || 0
    @exited_count = User.exited.count || 0
    @users_count = User.count || 0
    @max_score = User.maximum(:total_score) || 0
  end
end
