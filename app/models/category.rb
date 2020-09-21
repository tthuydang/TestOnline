class Category < ApplicationRecord
  has_many :tickets
  belongs_to :user
  validates :title, length: {minimum: 2}, presence: true, uniqueness: {case_sensitive: false}
  mount_uploader :image, AvatarUploader
end
