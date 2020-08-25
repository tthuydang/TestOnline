class Guest::TicketsController < ApplicationController

  def index
    @ticket = Ticket.where(code: params[:code]).first
  end
end
