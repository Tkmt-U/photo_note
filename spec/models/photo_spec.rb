require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe "バリデーションチェック" do
    context "imageを入力していない場合" do
      let(:photo) { Photo.new(image: nil) }
      it "エラーメッセージが表示される" do
        expect(photo).not_to be_valid
        expect(photo.errors[:image]).to include("can't be blank")
      end
    end
    context "titleを入力していない場合" do
      let(:photo) { Photo.new(title: nil) }
      it "エラーメッセージが表示される" do
        expect(photo).not_to be_valid
        expect(photo.errors[:title]).to include("can't be blank")
      end
    end
    context "cameraを入力していない場合" do
      let(:photo) { Photo.new(camera: nil) }
      it "エラーメッセージが表示される" do
        expect(photo).not_to be_valid
        expect(photo.errors[:camera]).to include("can't be blank")
      end
    end
  end

  describe "アソシエーション" do
    context "userモデル" do
      it "userモデルとの関係はbelongs_toか" do
        expect(Photo.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context "favoriteモデル" do
      it "favoriteモデルとの関係はhas_manyか" do
        expect(Photo.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end
