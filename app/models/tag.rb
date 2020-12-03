class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy
  has_many :photos, through: :tag_relationships
end