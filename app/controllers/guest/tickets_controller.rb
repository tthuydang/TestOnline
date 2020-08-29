class Guest::TicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @ticket = Ticket.where(code: params[:code]).first
    @questions = Question.where(ticket_id: @ticket.id)
  end
end
