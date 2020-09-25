class Creator::HistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :shared_pages
  before_action :check_if_creator

  def history
    ticket = Ticket.find_by(code: params[:code])
    histories = History.where(ticket_id: ticket.id).where.not(completed_time: nil)
  end

  def index
    History.where(:completed_time => nil).destroy_all
    @histories = History.where(user_id: current_user.id).order(updated_at: :desc)
  end

  def report_exam
    begin
      details = History.where(user_id: current_user.id, id: params[:id]).first.history_details
      @code_exam = details.first.history.ticket.code
      @answers_id = details.map(&:answer_id) # mang answer_id cac dap an dc chon
      @questions = details.first.history.ticket.questions
    rescue => exception
      redirect_to root_path
    end
  end
end
