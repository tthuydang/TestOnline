class Creator::SubticketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @subtickets = Subticket.all
  end

  def show
    @subticket = Subticket.find(params[:id])
  end

  def new
    @subtickets = Subticket.new
  end

  def edit
    @subtickets = Subticket.find(params[:id])
  end

  def create
    @subticket = Subticket.new(subticket_params)
    if @subticket.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @subtickets = Subticket.find(params[:id])
    if @subticket.delete
      redirect_to root_path
    else
      render :destroy
    end
  end

  private

  def subticket_params
    params.require(:subticket).permit(:id, :code, :content, :ticket_id)
  end
end
