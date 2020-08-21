class Ticket < ApplicationRecord
  belongs_to :category
  belongs_to :user

  mount_uploader :image, AvatarUploader
end
