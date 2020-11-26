require 'rails_helper'

RSpec.describe "homes controller" do
  describe "ログイン前のヘッダーの表示" do
    before do
      visit "/"
    end
    context "aboutページの表示" do
      before do
        click_on "about"
      end
      it "遷移に成功する" do
        expect(current_path).to eq homes_about_path
      end
    end
    context "投稿一覧ページ" do
      before do
        click_on "投稿一覧"
      end
      it "遷移に成功する" do
        expect(current_path).to eq "/"
      end
    end
    context "新規登録ページ" do
      before do
        click_on "新規登録"
      end
      it "遷移に成功する" do
        expect(current_path).to eq new_user_registration_path
      end
    end
    context "ログインページ" do
      before do
        click_on "ログイン"
      end
      it "遷移に成功する" do
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ログイン後のヘッダーの表示" do
    before do
      @user = create(:user)
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'login'
    end
    context "マイページの表示" do
      before do
        click_on "マイページ"
      end
      it "遷移に成功する" do
        expect(current_path).to eq users_mypage_path
      end
    end
    context "投稿一覧の表示" do
      before do
        click_on "投稿一覧"
      end
      it "遷移に成功する" do
        expect(current_path).to eq "/"
      end
    end
    context "新規投稿の表示" do
      before do
        click_on "新規投稿"
      end
      it "遷移に成功する" do
        expect(current_path).to eq new_photo_path
      end
    end
    context "ログアウトの表示" do
      before do
        click_on "ログアウト"
      end
      it "遷移に成功する" do
        expect(current_path).to eq "/"
      end
    end
  end

  describe "aboutページ" do
    context "表示の確認" do
      before do
        visit homes_about_path
      end
      it "主語が表示されている" do
        expect(page).to have_content ("photo noteは")
      end
      it "述語が表示されている" do
        expect(page).to have_content ("サイトです。")
      end
    end
  end
end