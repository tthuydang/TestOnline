class Guest::ExamController < ApplicationController
  before_action :authenticate_user!

  def index
    begin
      @ticket = Ticket.where(code: params[:code], delete_at: nil).first
      @questions = Question.where(ticket_id: @ticket.id, delete_at: nil)
    rescue => exception
      redirect_to root_path
    end
  end

  def oncheckboxchange
    curr_answer = Answer.find(params[:answer_id])
    puts "---- #{curr_answer.inspect}"
  end
end
