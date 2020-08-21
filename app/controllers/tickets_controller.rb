class TicketsController < ApplicationController
  before_action :check_creator

  def check_creator
    if current_user == nil || current_user.role != "CREATOR"
      redirect_to root_path
    end
  end

  def index
    @tickets = current_user.tickets
  end

  def new
    @ticket = Ticket.new
    @categories = Category.all
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.save
    redirect_to tickets_path
    # render plain: ticket_params
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      redirect_to tickets_path
    else
      redirect_to :edit
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to tickets_path
  end

  private

  def ticket_params
    params.require(:ticket).permit(:code, :title, :image, :description, :max_time, :category_id, :user_id)
  end

end
