class Ticket < ApplicationRecord
  belongs_to :category
  belongs_to :user
  validates :code, length: { minimum: 4 }, presence: true, uniqueness: { case_sensitive: false }
  validates :title, length: { minimum: 6 }, presence: true
  validates :description, presence: true
  validates :max_time, presence: true
  validates :competition_code, length: { minimum: 2 }
  mount_uploader :image, AvatarUploader
  has_many :questions
  has_many :subtickets
end
