require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /linetrace" do
    it "returns http success" do
      get "/static_pages/linetrace"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /ai" do
    it "returns http success" do
      get "/static_pages/ai"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /led" do
    it "returns http success" do
      get "/static_pages/led"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /iot" do
    it "returns http success" do
      get "/static_pages/iot"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /dflab" do
    it "returns http success" do
      get "/static_pages/dflab"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /game" do
    it "returns http success" do
      get "/static_pages/game"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /other" do
    it "returns http success" do
      get "/static_pages/other"
      expect(response).to have_http_status(:success)
    end
  end

end
