class WelcomeController < ApplicationController

  def index
    @tickets = Ticket.all
  end
end
