require 'rails_helper'

RSpec.describe "photos controller" do
  before do
    # ログイン作業
    @user = create(:user)
    visit new_user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'login'
    # ログイン作業ここまで
    @photo = create(:photo) # 投稿作成
  end

  describe "新規投稿" do
    before do
      visit new_photo_path
    end
    context "投稿に成功する" do
      before do
        attach_file "photo[image]", "#{Rails.root}/spec/image/IMG_5297.JPG"
        fill_in "photo[title]", with: "タイトル"
        fill_in "photo[camera]", with: "カメラ"
        fill_in "photo[lens]", with: "レンズ"
        fill_in "photo[shutter_speed]", with: "1/100"
        fill_in "photo[f_value]", with: "2.8"
        fill_in "photo[iso]", with: "100"
        fill_in "photo[item]", with: "なし"
        fill_in "photo[comment]", with: "コメント"
      end
      it "保存の確認" do
        expect{ click_on "保存する" }.to change{ Photo.count }.by(+1)
      end
      it "ページ遷移の確認" do
        click_on "保存する"
        expect(current_path).to eq photo_path(2) # 上記before節で作ったデータの詳細ページ
      end
    end
    context "投稿に失敗する" do
      before do
        attach_file 'photo[image]', "#{Rails.root}/spec/image/IMG_5297.JPG"
        fill_in "photo[title]", with: ''
        fill_in "photo[camera]", with: 'カメラ'
      end
      it "保存の確認" do
        expect{ click_on "保存する" }.to change{ Photo.count }.by(0)
      end
      it "メッセージの確認" do
        click_on "保存する"
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe "投稿詳細" do
    before do
      visit photo_path(@photo)
    end
    context "表示確認" do
      it "画像が表示される" do
        expect(page).to have_selector("img[src$='/image']")
      end
      it "タイトルの表示" do
        expect(page).to have_content "Title"
      end
      it "機材の表示" do
        expect(page).to have_content "Camera"
      end
      it "レンズの表示" do
        expect(page).to have_content "Lens"
      end
      it "シャッタースピードの表示" do
        expect(page).to have_content "1/80"
      end
      it "F値の表示" do
        expect(page).to have_content "4"
      end
      it "ISO感度の表示" do
        expect(page).to have_content "64000"
      end
      it "アイテムの表示" do
        expect(page).to have_content "Item"
      end
      it "コメントの表示" do
        expect(page).to have_content "Comment"
      end
    end
    context "リンクの確認" do
      before do
        click_on "編集する"
      end
      it "投稿詳細にリンクする" do
        expect(current_path).to eq edit_photo_path(@photo)
      end
    end
    context "削除機能" do
      before do
        click_on "削除する"
      end
      it "削除に成功する" do
        expect{
          expect(page.accept_confirm).to eq "本当に削除してよろしいですか？"
          expect(page).to have_content "Destroy successful"
        }.to change{ Photo.count }.by(-1)
      end
      it "ページ遷移の確認" do
        page.accept_confirm "本当に削除してよろしいですか？"
        sleep 1 # jsの動作完了待ちのため処理を停止
        expect(current_path).to eq "/"
      end
      it "キャンセルする" do
        expect{
          expect(page.dismiss_confirm).to eq "本当に削除してよろしいですか？"
          expect(current_path).to eq photo_path(@photo)
        }.to change{ Photo.count }.by(0)
      end
    end
    context "他ユーザの投稿詳細の場合" do
      before do
        # 他ユーザの登録
        click_on 'ログアウト'
        visit new_user_registration_path
        fill_in 'user[name]', with: "user1"
        fill_in 'user[email]', with: "user1@example.com"
        fill_in 'user[password]', with: "Password"
        fill_in 'user[password_confirmation]', with: "Password"
        click_on '登録'
        # 他ユーザの登録ここまで
        visit photo_path(@photo)
      end
      it "編集ボタンが表示されない" do
        expect(page).not_to have_content("編集する")
      end
      it "削除ボタンが表示されない" do
        expect(page).not_to have_content("削除する")
      end
    end
  end

  describe "投稿一覧" do
    before do
      visit "/"
    end
    context "表示確認" do
      it "画像が表示される" do
        expect(page).to have_selector("img[src$='/image']")
      end
      it "ユーザ名が表示される" do
        expect(page).to have_content(@photo.user.name)
      end
      it "タイトルが表示される" do
        expect(page).to have_content(@photo.title)
      end
    end
    context "リンク確認" do
      it "ユーザ詳細にリンクする" do
        click_on @photo.user.name
        expect(current_path).to eq user_path(@user)
      end
      it "投稿詳細にリンクする" do
        click_on @photo.title
        expect(current_path).to eq photo_path(@photo)
      end
    end
  end

  describe "投稿編集" do
    before do
      visit edit_photo_path(@photo)
    end
    context "画像の変更" do
      before do
        attach_file 'photo[image]', "#{Rails.root}/spec/image/A924E64C-F273-411B-8DF1-53044702CD8F_1_105_c.jpeg"
        click_on "保存する"
      end
      it "成功する" do
        expect(current_path).to eq photo_path(@photo)
      end
    end
    context "タイトルの変更" do
      it "成功する" do
        fill_in "photo[title]", with: "titletitle"
        click_on "保存する"
        expect(current_path).to eq photo_path(@photo)
      end
      it "失敗する" do
        fill_in "photo[title]", with: nil
        click_on "保存する"
        expect(page).to have_content ("Title can't be blank")
      end
    end
    context "機材の変更" do
      it "成功する" do
        fill_in "photo[camera]", with: "titletitle"
        click_on "保存する"
        expect(current_path).to eq photo_path(@photo)
      end
      it "失敗する" do
        fill_in "photo[camera]", with: nil
        click_on "保存する"
        expect(page).to have_content ("Camera can't be blank")
      end
    end
  end

  describe "非ログイン時" do
    before do
      click_on "ログアウト"
    end
    context "新規投稿画面に遷移" do
      before do
        visit new_photo_path
      end
      it "失敗する" do
        expect(current_path).not_to eq new_photo_path
        expect(response.status).to eq 200
      end
    end
    context "投稿詳細に遷移" do
      before do
        visit photo_path(@photo)
      end
      it "失敗する" do
        expect(current_path).not_to eq photo_path(@photo)
        expect(response.status).to eq 200
      end
    end
    context "投稿編集に遷移" do
      before do
        visit photo_path(@photo)
      end
      it "失敗する" do
        expect(current_path).not_to eq photo_path(@photo)
        expect(response.status).to eq 200
      end
    end
    context "投稿詳細に遷移" do
      before do
        visit edit_photo_path(@photo)
      end
      it "失敗する" do
        expect(current_path).not_to eq edit_photo_path(@photo)
        expect(response.status).to eq 200
      end
    end
  end
end