class Guest::CompetitionController < ApplicationController

  def index
    category = Category.find_by(title: params[:subject])
    @tickets = category.tickets.where.not(start_date: nil, finish_date: nil, competition_code: nil)
  end

  def confirm
    if params[:code]
      @ticket = Ticket.where(code: params[:code]).first
    else
      redirect_to root_path
    end
  end

  def confirm_code
    ticket = Ticket.find(params[:ticket_id])
    now = DateTime.now.strftime("%d/%m/%Y")
    if ticket.start_date.strftime("%d/%m/%Y") < now || now > ticket.finish_date.strftime("%d/%m/%Y")
      flash[:notice] = "This ticket is outdated. Please choose another one!"
      redirect_back(fallback_location: confirm_path)
    elsif params[:competition_code].to_s != ticket.competition_code
      flash[:notice] = "Competition code is invalid. Please check your code and try again!"
      redirect_back(fallback_location: confirm_path)
    else
      redirect_to exam_index_path(code: ticket.code)
    end
  end
end
