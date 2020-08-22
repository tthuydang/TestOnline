class Category < ApplicationRecord
  belongs_to :user
  validates :title, length: {minimum: 2}, presence: true, uniqueness: {case_sensitive: false}
end
