class WelcomeController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @tickets = pagy(Ticket.all, items: 2)
  end
end
