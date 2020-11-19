class Photo < ApplicationRecord
  has_many :favorites, dependent: :destroy
  belongs_to :user

  attachment :image

  validates :image, presence: true
  validates :title, presence: true
  validates :camera, presence: true

  def favorited?(user)
    unless user.nil?
      favorites.where(user_id: user.id).exists?
    end
  end

  def self.sort(selection)
    case selection
    when 'new' then
      return all.order(created_at: :DESC)
    when 'old' then
      return all.order(created_at: :ASC)
    when 'many_favorites' then
      return all.order(favorites_quantity: :desc)
    when 'little_favorites' then
      return all.order(favorites_quantity: :ASC)
    end
  end
end
