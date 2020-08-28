class Question < ApplicationRecord
  attr_accessor :dsAnswers
  belongs_to :ticket
  has_many :answers, dependent: :destroy
  dsAnswers = nil
end
