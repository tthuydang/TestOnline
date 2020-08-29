class Subticket < ApplicationRecord
  attr_accessor :amount, :result_ques, :result_ans

  belongs_to :ticket
end
