class Guest::TicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @ticket = Ticket.where(code: params[:code], delete_at: nil).first
    @questions = Question.where(ticket_id: @ticket.id, delete_at: nil)
  end
end
