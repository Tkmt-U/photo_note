class Photo < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships
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
      return all.order(favorites_quantity: :DESC)
    when 'little_favorites' then
      return all.order(favorites_quantity: :ASC)
    end
  end

  def save_tags(tag_list)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tag_list
    new_tags = tag_list - current_tags

    old_tags.each do |old_tag|
      self.tags.delete Tag.find_by(name: old_tag)
    end
    new_tags.each do |new_tag|
      new_photo_tag = Tag.find_or_create_by(name: new_tag)
      self.tags << new_photo_tag
    end
  end
end

