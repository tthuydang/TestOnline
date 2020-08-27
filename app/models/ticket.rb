class Ticket < ApplicationRecord
  belongs_to :category
  belongs_to :user
  validates :code, length: {minimum: 4}, presence: true, uniqueness: {case_sensitive: false}
  validates :title, length: {minimum: 6}, presence: true
  validates :description, presence: true
  validates :max_time, presence: true
  mount_uploader :image, AvatarUploader
end
