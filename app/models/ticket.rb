class Ticket < ApplicationRecord
  has_many :questions #, dependent: :destroy
  has_many :sub_tickets #, dependent: :destroy
  has_many :histories #, dependent: :destroy
  belongs_to :category
  belongs_to :user
end
