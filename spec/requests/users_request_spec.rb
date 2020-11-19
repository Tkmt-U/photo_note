require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /show" do
    context '詳細ページの表示' do
      before do
        get "/users/:id"
      end
      it "returns http success" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "GET /mypage" do
    context 'マイページの表示' do
      before do
        get "/users/mypage"
      end
      it "returns http success" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "GET /edit" do
    context '編集ページの表示'
      before do
        get "/users/:id/edit"
      end
      it "returns http success" do
        expect(response.status).to eq 200
      end
    end
  end

end
