class Creator::SubticketsController < ApplicationController
  before_action :authenticate_user!

  # def index
  #   @subtickets = Subticket.all
  # end

  # def show
  #   @subticket = Subticket.find(params[:id])
  # end

  def new
  end

  def create
    @subticket = Subticket.new
    @subticket.ticket_id = Ticket.where(code: params[:code]).first.id
    if @subticket.save
      redirect_to root_path
    else
      render :new
    end
  end

  # def destroy
  #   @subtickets = Subticket.find(params[:id])
  #   if @subticket.delete
  #     redirect_to root_path
  #   else
  #     render :destroy
  #   end
  # end

  private

  def subticket_params
    params.require(:subticket).permit(:code, :content, :amount, :result_ques, :result_ans)
  end

  def make_subticket(amout, result_ques, result_ans)
    i = 0
    while i > amout
    end
  end
end
