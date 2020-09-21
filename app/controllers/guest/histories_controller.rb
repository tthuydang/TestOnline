class Guest::HistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :shared_pages

  def index
    History.where(:completed_time => nil).destroy_all
    @histories = History.where(user_id: current_user.id).order(updated_at: :desc)
  end

  def report_exam
    details = HistoryDetail.where(history_id: params[:id])
    @stt = details.first.history.id
    @code_exam = details.first.history.ticket.code
    @answers_id = details.map(&:answer_id) # mang answer_id cac dap an dc chon
    @questions = details.first.history.ticket.questions
  end
end
