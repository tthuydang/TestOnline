class HistoryDetail < ApplicationRecord
  belongs_to :question
  belongs_to :answer
  belongs_to :history
end
