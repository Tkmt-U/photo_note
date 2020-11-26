require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/users/:id"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /mypage" do
    it "returns http success" do
      get "/users/mypage"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/users/:id/edit"
      expectexpect(response).to have_http_status(:success)
    end
  end

end