class Guest::TicketsController < ApplicationController
  before_action :shared_pages
  include Pagy::Backend

  def index
    curr_category = Category.find_by_title(params[:subject])
    if curr_category != nil
      @title = curr_category.title
      @pagy, @tickets = pagy(Ticket.where(category_id: curr_category.id, delete_at: nil), items: 6)
    else
      @title = "Newest tickets"
      @pagy, @tickets = pagy(Ticket.where(delete_at: nil), items: 6)
    end
  end

  def intro
    @ticket = Ticket.where(code: params[:code], delete_at: nil).first
    redirect_to root_path if @ticket == nil
  end
end
