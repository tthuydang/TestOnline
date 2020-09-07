class Guest::TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :map_giao_dien, only: [:exam]
  include Pagy::Backend

  def index
    curr_category = Category.find_by_title(params[:subject])
    if curr_category != nil
      @title = curr_category.title
      @pagy, @tickets = pagy(Ticket.where(category_id: curr_category.id, delete_at: nil), items: 3)
    else
      @title = "Newest tickets"
      @pagy, @tickets = pagy(Ticket.where(delete_at: nil), items: 6)
    end
  end

  def exam
    @ticket = Ticket.where(code: params[:code], delete_at: nil).first
    @questions = Question.where(ticket_id: @ticket.id, delete_at: nil)
  end

  private

  def map_giao_dien
    @exam = true
  end
end
