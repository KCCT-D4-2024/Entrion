module Api
  module V1
    class GameScoresController < ApplicationController
      # post /api/v1/game_scores
      skip_before_action :verify_authenticity_token

      def create
        game = Game.find_by(title: params[:game_name])
        unless game
          game = Game.create(title: params[:game_name])
        end
        return render json: { success: false, message: "Game not found" }, status: :not_found unless game

        user = User.find(params[:user_id])
        return render json: { success: false, message: "User not found" }, status: :not_found unless user

        game_score = GameScore.find_by(user_id: params[:user_id], game_id: game.id)

        if game_score
          if game_score.score < params[:score].to_i
            user.update(total_score: user.total_score + params[:score].to_i - game_score.score)
            game_score.update(score: params[:score])
            render json: { success: true, message: "Game score updated successfully", game_score: game_score }
          else
            render json: { success: true, message: "Game score not updated", game_score: game_score }
          end
        else
          game_score = GameScore.new(
            user_id: params[:user_id],
            game_id: game.id,
            score: params[:score]
          )
          if game_score.save
            user.update(total_score: user.total_score + params[:score].to_i)
            render json: { success: true, message: "Game score saved successfully", game_score: game_score }
          else
            render json: { success: false, message: "Game score not saved", game_score: game_score }
          end
        end
      end
    end
  end
end
