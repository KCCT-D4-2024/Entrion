class GameScoresController < ApplicationController
  # POST /game_scores
  def create
    game = Game.find_or_create_by(title: game_score_params[:game_name])

    unless game
      flash[:alert] = "Game not found"
      return redirect_to new_game_score_path
    end

    user = User.find(game_score_params[:user_id])
    unless user
      flash[:alert] = "指定のユーザーが見つかりません"
      return redirect_to new_game_score_path
    end

    game_score = GameScore.find_by(user_id: user.id, game_id: game.id)

    if game_score
      if game_score.score < game_score_params[:score].to_i
        user.update(total_score: user.total_score + game_score_params[:score].to_i - game_score.score)
        game_score.update(score: game_score_params[:score])
        flash[:notice] = "ゲームスコアが正常に更新されました"
      else
        flash[:notice] = "ゲームスコアは更新されませんでした"
      end
    else
      game_score = GameScore.new(
        user_id: user.id,
        game_id: game.id,
        score: game_score_params[:score]
      )
      if game_score.save
        user.update(total_score: user.total_score + game_score_params[:score].to_i)
        flash[:notice] = "ゲームスコアが正常に保存されました"
      else
        flash[:alert] = "ゲームスコアが保存されませんでした"
      end
    end

    redirect_to game_scores_path
  end

  # Optional: You can add an index or new action to render views for this controller
  def new
    @game_score = GameScore.new
  end

  def index
    @game_scores = GameScore.all
  end

  private

  # ストロングパラメータを定義
  def game_score_params
    params.require(:game_score).permit(:user_id, :game_name, :score)
  end
end
