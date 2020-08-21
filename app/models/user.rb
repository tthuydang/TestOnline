class User < ApplicationRecord
  has_many :categories

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  VALID_NAME_REGEX = /\A[^0-50`!@#\$%\^&*+_=]+\z/i
  validates :firstname, :lastname, presence: true, format: { with: VALID_NAME_REGEX }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  mount_uploader :avatar, AvatarUploader
end
