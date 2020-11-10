class Photo < ApplicationRecord
  has_many :favorites, dependent: :destroy
  belongs_to :user

  attachment :image

  # validates :image, presence: true
  validates :title, presence: true
  validates :camera, presence: true
end
