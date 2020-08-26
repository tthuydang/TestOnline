class Guest::TicketsController < ApplicationController

  def index
    @ticket = Ticket.where(code: params[:code]).first
    @questions = Question.where(ticket_id: @ticket.id)
  end
end
