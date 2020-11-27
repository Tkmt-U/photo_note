require 'rails_helper'

RSpec.describe "users controller" do
  before do
    @user = create(:user)
    visit new_user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'login'
  end

  describe "新規登録" do
    before do
      click_on "ログアウト"
      visit new_user_registration_path
      fill_in "user[name]", with: "user1"
      fill_in "user[email]", with: "user1@example.com"
      fill_in "user[password]", with: "Password"
      fill_in "user[password_confirmation]", with: "Password"
    end
    context "登録" do
      it "成功する" do
        expect{ click_on "登録" }.to change{ User.count }.by(1)
      end
      it "ページ遷移の確認" do
        click_on "登録"
        expect(current_path).to eq "/"
      end
    end
    context "ログアウト" do
      before do
        click_on "登録"
        visit users_mypage_path # ページの遷移を確認するため"/"以外に遷移
        click_on "ログアウト"
      end
      it "ページ遷移の確認" do
        expect(current_path).to eq "/"
      end
      it "ログアウトの確認" do
        expect(page).to have_content "about"
      end
    end
  end

  describe "詳細ページ" do
    context "詳細ページの表示" do
      before do
        visit user_path(@user)
      end
      it "アクセスに成功する" do
        expect(current_path).to eq user_path(@user)
      end
      it "ユーザ名が表示される" do
        expect(page).to have_content (@user.name)
      end
    end
  end

  describe "マイページ" do
    before do
      visit users_mypage_path
    end
    context "マイページの表示" do
      it "アクセスに成功する" do
        expect(current_path).to eq users_mypage_path
      end
      it "名前が表示される" do
        expect(page).to have_content (@user.name)
      end
      it "メールアドレスが表示される" do
        expect(page).to have_content (@user.email)
      end
      it "投稿数が表示される" do
        expect(page).to have_content (@user.photos.count)
      end
    end
    context "詳細ページに遷移" do
      before do
        click_on @user.photos.count
      end
      it "遷移に成功する" do
        expect(current_path).to eq user_path(@user)
      end
    end
    context "編集画面に遷移" do
      before do
        click_on "登録情報を編集する"
      end
      it "遷移に成功する" do
        expect(current_path).to eq edit_user_path(@user)
      end
    end
    context "パスワード変更画面に遷移" do
      before do
        click_on "パスワードを変更する"
      end
      it "遷移に成功する" do
        expect(current_path).to eq edit_user_registration_path
      end
    end
  end

  describe "編集ページ" do
    before do
      visit edit_user_path(@user)
    end
    context "編集ページの表示" do
      it "アクセスに成功する" do
        expect(current_path).to eq edit_user_path(@user)
      end
    end
    context "名前の変更" do
      it "成功する" do
        fill_in "user[name]", with: "namename"
        click_on "保存する"
        expect(current_path).to eq users_mypage_path
      end
      it "失敗する" do
        fill_in "user[name]", with: nil
        click_on "保存する"
        expect(page).to have_content ("Name can't be blank")
      end
    end
    context "メールアドレスの変更" do
      it "成功する" do
        fill_in "user[email]", with: "mail@example.com"
        click_on "保存する"
        expect(current_path).to eq users_mypage_path
      end
      it "失敗する" do
        fill_in "user[email]", with: nil
        click_on "保存する"
        expect(page).to have_content ("Email can't be blank")
      end
    end
    context "他人の編集画面への遷移" do
      before do
        # 他ユーザの登録
        click_on 'ログアウト'
        visit new_user_registration_path
        fill_in "user[name]", with: "user1"
        fill_in "user[email]", with: "user1@example.com"
        fill_in "user[password]", with: "Password"
        fill_in "user[password_confirmation]", with: "Password"
        click_on "登録"
        # 他ユーザの登録ここまで
        visit edit_user_path(@user)
      end
      it "マイページに遷移する" do
        expect(current_path).to eq users_mypage_path
      end
    end
  end

  describe "パスワード変更画面" do
    before do
      visit edit_user_registration_path
    end
    context "パスワード変更に成功する" do
      before do
        fill_in "user[current_password]", with: "Password"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_on "更 新"
      end
      it "成功する" do
        expect(current_path).to eq "/"
      end
    end
    context "パスワード変更に失敗する" do
      it "current_passwordが違う場合" do
        fill_in "user[current_password]", with: "password"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_on "更 新"
        expect(current_path).not_to eq "/"
        expect(response.status).to eq 200
      end
      it "passwordが6文字未満の場合" do
        fill_in "user[current_password]", with: "Password"
        fill_in "user[password]", with: "pword"
        fill_in "user[password_confirmation]", with: "pword"
        click_on "更 新"
        expect(current_path).not_to eq "/"
        expect(response.status).to eq 200
      end
      it "passwordが一致しない場合" do
        fill_in "user[current_password]", with: "password"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "possward"
        click_on "更 新"
        expect(current_path).not_to eq "/"
        expect(response.status).to eq 200
      end
    end
  end

  describe "退会処理" do
    before do
      visit edit_user_registration_path
    end
    context "退会処理" do
      before do
        click_on "退会する"
      end
      it "成功する" do
        expect{
          expect(page.accept_confirm).to eq "本当に退会してよろしいですか？"
          expect(page).to have_content "Your account has been successfully cancelled."
        }.to change{ User.count }.by(-1)
      end
      it "ページ遷移の確認" do
        expect{
          expect(page.accept_confirm).to eq "本当に退会してよろしいですか？"
          expect(page).to have_content "Your account has been successfully cancelled."
          expect(current_path).to eq "/"
        }
      end
      it "キャンセルする" do
        expect{
          expect(page.dismiss_confirm).to eq "本当に退会してよろしいですか？"
          expect(current_path).to eq edit_user_registration_path
        }.to change{ User.count }.by(0)
      end
    end
    context "戻るボタン" do
      before do
        click_on "戻る"
      end
      it "ページ遷移の確認" do
        expect(current_path).to eq users_mypage_path
      end
    end
  end

  describe "非ログイン時" do
    before do
      click_on "ログアウト"
    end
    context "ページ遷移の確認" do
      it "トップ画面に遷移" do
        expect(current_path).to eq "/"
      end
      it "メッセージの確認" do
        expect(page).to have_content "Signed out successfully."
      end
    end
    context "ユーザ詳細に遷移" do
      before do
        user_path(@user)
      end
      it "失敗する" do
        expect(current_path).not_to eq user_path(@user)
        expect(response.status).to eq 200
      end
    end
    context "マイページに遷移" do
      before do
        visit users_mypage_path
      end
      it "失敗する" do
        expect(current_path).not_to eq users_mypage_path
        expect(response.status).to eq 200
      end
    end
    context "編集画面に遷移" do
      before do
        edit_user_path(@user)
      end
      it "失敗する" do
        expect(current_path).not_to eq edit_user_path(@user)
        expect(response.status).to eq 200
      end
    end
  end
end
