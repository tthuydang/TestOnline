class Creator::TicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tickets = current_user.tickets
  end

  def new
    @ticket = Ticket.new
    @categories = Category.all
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user_id = current_user.id
    if @ticket.save
      redirect_to tickets_path
    else
      render :new
    end
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      redirect_to tickets_path
    else
      render :edit
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to tickets_path
  end

  private

  def ticket_params
    params.require(:ticket).permit(:code, :title, :image, :description, :max_time, :category_id)
  end
end
