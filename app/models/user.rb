class User < ApplicationRecord
  has_many :histories #, dependent: :destroy
  has_many :tickets #, dependent: :destroy
  has_secure_password
end
