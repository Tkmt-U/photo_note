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
      # return find(Favorite.group(:photo_id).order(Arel.sql('count(photo_id) desc')).pluck(:photo_id))
      # return(all.sort do |a, b|
      #   a[favorites_quantity.count] <=> b[favorites_quantity.count]
      # end)

    when 'little_favorites' then
      # return find(Favorite.group(:photo_id).order(Arel.sql('count(photo_id) asc')).pluck(:photo_id))
      return all.order(favorites_quantity: :ASC)
    end
  end
end
