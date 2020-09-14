class Creator::HistoriesController < ApplicationController
  before_action :authenticate_user!

  def history
    ticket = Ticket.find_by(code: params[:code])
    histories = History.where(ticket_id: ticket.id).where.not(completed_time: nil)
  end
end
