require 'rails_helper'
# 処理の途中に出てくる「visit ~」は、「Chromedriverは非推奨だから、Webdriverにしてね」というメッセージが出てくるのでリロードしています。
# Webdriver使うとテストが走らないのでChromedriver使っています。

describe "favorites controller" do
  before do
    @user = create(:user)
    visit new_user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'login'
    @photo = create(:photo)
  end
  describe "一覧画面" do
    context "お気に入りする" do
      before do
        visit "/"
        find('#fav-icon').click
      end
      it "ページの遷移" do
        expect(current_path).to eq "/"
      end
      it "お気に入りを確認する", js: true do
        visit "/"
        expect(page).to have_css '#unfav-icon'
      end
    end
    context "お気に入りを外す" do
      before do
        visit "/"
        find('#fav-icon').click
        visit "/"
        find('#unfav-icon').click
      end
      it "ページの遷移" do
        expect(current_path).to eq "/"
      end
      it "お気に入りを外す", js: true do
        visit "/"
        expect(page).to have_css '#fav-icon'
      end
    end
  end
  describe "投稿詳細" do
    context "お気に入りする" do
      before do
        visit photo_path(@photo)
        find('#fav-icon').click
      end
      it "ページの遷移" do
        expect(current_path).to eq photo_path(@photo)
      end
      it "お気に入りを確認する", js: true do
        visit photo_path(@photo)
        expect(page).to have_css '#unfav-icon'
      end
    end
    context "お気に入りを外す" do
      before do
        visit photo_path(@photo)
        find('#fav-icon').click
        visit photo_path(@photo)
        find('#unfav-icon').click
      end
      it "ページの遷移" do
        expect(current_path).to eq photo_path(@photo)
      end
      it "お気に入りを外す", js: true do
        visit photo_path(@photo)
        expect(page).to have_css '#fav-icon'
      end
    end
  end
end