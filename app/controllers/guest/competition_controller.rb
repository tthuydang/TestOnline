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
    ticket = Ticket.find_by(id: params[:ticket_id], competition_code: params[:competition_code])
    if ticket == nil
      flash[:notice] = "Competition code is invalid. Please check your code and try again!"
      redirect_back(fallback_location: confirm_path)
    else
      now = DateTime.now.strftime("%d/%m/%Y - %H:%M:%S")
      if ticket.start_date.strftime("%d/%m/%Y - %H:%M:%S") <= now && ticket.finish_date.strftime("%d/%m/%Y - %H:%M:%S") >= now
        redirect_to intro_path(code: ticket.code)
      else
        flash[:notice] = "This ticket is outdated. Please choose another one!"
        redirect_back(fallback_location: confirm_path)
      end
    end
  end
end
