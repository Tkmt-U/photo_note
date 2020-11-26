require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    context "正常に登録される" do
      before do
        @user = User.new(name: "uuuuuu", email: "mail@mail", password: "uuuuuu",  password_confirmation: 'uuuuuu')
      end
      it "エラーメッセージは表示されない" do
        expect(@user).to be_valid
      end
    end
    context "nameを入力していない場合" do
      before do
        @user = User.new(name: nil)
      end
      it "エラーメッセージが表示される" do
        expect(@user).not_to be_valid
        expect(@user.errors[:name]).to include("can't be blank")
      end
    end
    context "mailを入力していない" do
      before do
        @user = User.new(email: nil)
      end
      it "エラーメッセージが表示される" do
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to include("can't be blank")
      end
    end
    context "passwordを入力していない" do
      before do
        @user = User.new(password: nil)
      end
      it "エラーメッセージが表示される" do
        expect(@user).not_to be_valid
        expect(@user.errors[:password]).to include("can't be blank")
      end
    end
  end

  describe "アソシエーション" do
    context "photoモデル" do
      it "photoモデルとの関係はhas_manyか" do
        expect(User.reflect_on_association(:photos).macro).to eq :has_many
      end
    end
    context "favoriteモデル" do
      it "favoriteモデルとの関係はhas_manyか" do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end
