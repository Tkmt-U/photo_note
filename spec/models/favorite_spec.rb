require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe "アソシエーション" do
    context "userモデル" do
      it "userモデルとの関係はbelongs_toか" do
        expect(Favorite.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context "photoモデル" do
      it "photoモデルとの関係はbelongs_toか" do
        expect(Favorite.reflect_on_association(:photo).macro).to eq :belongs_to
      end
    end
  end
end
