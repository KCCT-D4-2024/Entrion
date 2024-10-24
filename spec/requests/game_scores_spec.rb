require 'rails_helper'

RSpec.describe "GameScores", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/game_scores/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/game_scores/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/game_scores/create"
      expect(response).to have_http_status(:success)
    end
  end

end
