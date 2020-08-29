class Creator::SubticketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @subtickets = Subticket.all
  end

  def show
    @subticket = Subticket.find(params[:id])
  end

  def new
    @subticket = Subticket.new
    @ticket = Ticket.where(code: params[:code]).first
  end

  def create
    @subticket = Subticket.new(subticket_params)
    if @subticket.save
      # make_subticket(amount, result_ques, result_ans)
      redirect_to subtickets_path
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
    params.require(:subticket).permit(:code, :ticket_id, :amount, :result_ques, :result_ans)
  end

  def make_subticket(amount, result_ques, result_ans)
    i = 0
    while i > amount
      if resul_ques == 1 && result_ans == 1
      elsif result_ques == 1 && result_ans == 0
      elsif result_ques == 0 && result_ans == 1
      else
      end
      i += 1
    end
  end

  def pick_ques
    ques = Ticket.where(ticket_id: params[:id]).questions
  end

  def pick_ans
    ans = Ticket.where(ticket_id: params[:id]).questions.where(question_id: param[:id]).answers
  end
end
