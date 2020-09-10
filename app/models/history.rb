class History < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  has_many :history_details, dependent: :destroy
end
