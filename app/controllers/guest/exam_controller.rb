class Guest::ExamController < ApplicationController
  before_action :authenticate_user!

  def index
    begin
      @ticket = Ticket.where(code: params[:code], delete_at: nil).first
      @questions = Question.where(ticket_id: @ticket.id, delete_at: nil)
    rescue => exception
      puts "---- error nè: #{exception}"
      redirect_to root_path
    end
  end

  def oncheckboxchange # lưu history_details
    create_history_and_session
    curr_answer = Answer.find(params[:answer_id])
    curr_history = History.find(session[:curr_history_id])
    # nếu session đã tồn tại nhưng là của đề thi khác(do lần trước chưa submit) thì xóa session đi
    if curr_history != nil && curr_answer.question.ticket_id != curr_history.ticket_id
      session.delete(:curr_history_id)
      create_history_and_session
    end
    curr_details = HistoryDetail.where(history_id: session[:curr_history_id], answer_id: curr_answer.id, question_id: curr_answer.question_id).first
    if curr_details == nil # nếu tích vô thì lưu
      # nếu là radio button
      if Question.find_by(id: curr_answer.question_id).answers.where(is_correct: true).size == 1
        ht = HistoryDetail.find_by(history_id: curr_history.id, question_id: curr_answer.question_id)
        ht.destroy if ht != nil
      end

      details = HistoryDetail.new
      details.history_id = session[:curr_history_id]
      details.answer_id = curr_answer.id
      details.question_id = curr_answer.question_id
      details.save
    else # nếu bỏ tích thì xóa
      curr_details.destroy
    end
  end

  # nếu ko submit thì ko lưu các trường như completed_time
  # => completed_time = nil => rác => xóa(cái này viết ở index của history)
  def finish # update lại history và history_detail
    if session[:curr_history_id] == nil
      flash[:notice] = "there is nothing to submit."
      redirect_back(fallback_location: exam_index_path)
    else
      history = History.find(session[:curr_history_id])
      history.total_correct = total_correct(history.ticket_id, history.id)
      history.is_passed = is_passed(history.total_question, history.total_correct)
      history.completed_time = completed_time(params[:time_complete].to_i)
      history.updated_at = Time.now
      history.save
      session.delete(:curr_history_id)
      redirect_to histories_path
    end
  end

  private

  # tạo mới history và session nếu session ko tồn tại
  def create_history_and_session
    if session[:curr_history_id] == nil # tạo mới 1 history và 2 cái session
      curr_history = History.new
      curr_history.total_question = Ticket.find(params[:ticket_id]).questions.size
      curr_history.total_correct = 0
      curr_history.is_passed = false
      curr_history.user_id = current_user.id
      curr_history.ticket_id = params[:ticket_id]
      curr_history.created_at = Time.now
      curr_history.updated_at = Time.now
      if curr_history.save
        session[:curr_history_id] = curr_history.id
      end
    end
  end

  def total_correct(ticket_id, history_id)
    total = 0
    questions = Ticket.find(ticket_id).questions
    questions.each do |quest|
      correct_answers = quest.answers.where(is_correct: true).map(&:id)
      selected_answers = HistoryDetail.where(question_id: quest.id, history_id: history_id).map(&:answer_id)
      total += 1 if correct_answers.difference(selected_answers).empty? && selected_answers.difference(correct_answers).empty?
    end
    total
  end

  def completed_time(time_complete_miliseconds)
    time_h = time_complete_miliseconds / (1000 * 60 * 60) % 60
    time_m = time_complete_miliseconds / (1000 * 60) % 60
    time_s = time_complete_miliseconds / 1000 % 60

    time_h = "0#{time_h}" if time_h.to_s.length == 1
    time_m = "0#{time_m}" if time_m.to_s.length == 1
    time_s = "0#{time_s}" if time_s.to_s.length == 1

    "#{time_h}:#{time_m}:#{time_s}"
  end

  def is_passed(total_question, total_correct)
    return (total_correct.to_f / total_question) > 0.5 ? true : false
  end
end
