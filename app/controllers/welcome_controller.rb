class WelcomeController < ApplicationController
  include Pagy::Backend

  def index
    curr_category = Category.find_by_title(params[:subject])
    if curr_category != nil
      @title = curr_category.title
      @pagy, @tickets = pagy(curr_category.tickets, items: 3)
    else
      @title = "Newest tickets"
      @pagy, @tickets = pagy(Ticket.all, items: 3)
    end
  end
end
