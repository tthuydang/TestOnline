class Guest::ExamController < ApplicationController
  before_action :authenticate_user!

  def index
    begin
      @ticket = Ticket.where(code: params[:code], delete_at: nil).first
      @questions = Question.where(ticket_id: @ticket.id, delete_at: nil)

      if session[:curr_history_id] == nil
        curr_history = History.new
        curr_history.total_question = @questions.size
        curr_history.total_correct = 0
        curr_history.is_passed = false
        curr_history.user_id = current_user.id
        curr_history.ticket_id = @ticket.id
        curr_history.created_at = Time.now
        curr_history.updated_at = Time.now
        if curr_history.save
          session.delete(:curr_history_id) # <<<< code thừa. mà thôi kệ mẹ nó vì anh yêu em
          session[:curr_history_id] = curr_history.id
          session[:start_time] = Time.now.to_s.split(" ")[1]
        end
      end
    rescue => exception
      puts "---- #{exception}"
      redirect_to root_path
    end
  end

  def oncheckboxchange # lưu history_details
    begin
      curr_answer = Answer.find(params[:answer_id])
      curr_his_detail = HistoryDetail.where(history_id: session[:curr_history_id], answer_id: curr_answer.id, question_id: curr_answer.question_id).first
      if curr_his_detail == nil # nếu tích vô thì lưu
        history_detail = HistoryDetail.new
        history_detail.history_id = session[:curr_history_id]
        history_detail.answer_id = curr_answer.id
        history_detail.question_id = curr_answer.question_id
        history_detail.save
      else # nếu bỏ tích thì xóa
        curr_his_detail.destroy
      end
    rescue => exception
      puts "---- #{exception}"
    end
  end

  def finish # update lại history
    history = History.find(session[:curr_history_id])

    puts "---- finish: #{params[:ticket_id]}"
    # tính total_correct
    # history.total_correct = ?
    # tính completed_time
    # history.completed_time = ?
    # kiểm tra is_passed
    # history.is_passed = ?
    # history.updated_at = Time.now
    puts "---- start_time: #{session[:start_time]}"




    session.delete(:curr_history_id)
    session.delete(:start_time)

    redirect_to histories_path
  end
end
