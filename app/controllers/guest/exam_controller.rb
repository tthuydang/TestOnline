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
      session.delete(:start_time)
      create_history_and_session
    end

    curr_details = HistoryDetail.where(history_id: session[:curr_history_id], answer_id: curr_answer.id, question_id: curr_answer.question_id).first
    if curr_details == nil # nếu tích vô thì lưu
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
    history = History.find(session[:curr_history_id])
    history.total_correct = total_correct(history.ticket_id, history.id)
    history.is_passed = is_passed(history.total_question, history.total_correct)
    history.completed_time = completed_time(session[:start_time])
    history.updated_at = Time.now
    history.save

    session.delete(:curr_history_id)
    session.delete(:start_time)

    redirect_to histories_path
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
        session[:start_time] = Time.now.strftime('%H:%M:%S').to_s
      end
    end
  end

  def total_correct(ticket_id, history_id)
    total = 0
    questions = Ticket.find(ticket_id).questions
    questions.each do |quest|
      correct_answers = quest.answers.where(is_correct: true).map(&:id)
      selected_answers = HistoryDetail.where(question_id: quest.id, history_id: history_id).map(&:answer_id)
      total += 1 if selected_answers & correct_answers == selected_answers # comparing two arrays ignoring element order
    end
    total
  end

  def completed_time(start_time)
    now = Time.parse(Time.now.strftime('%H:%M:%S'))
    start = Time.parse(start_time.to_s)
    Time.at(now - start).utc.strftime("%H:%M:%S")
  end

  def is_passed(total_question, total_correct)
    return (total_correct.to_f / total_question) > 0.5 ? true : false
  end
end