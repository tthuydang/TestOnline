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
    # đọc file rồi lưu câu hỏi vào database rồi mới save ticket sau
    file_path = ticket_params[:file_question].path
    read_file_text(file_path)



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
    params.require(:ticket).permit(:file_question, :code, :title, :image, :description, :max_time, :category_id)
  end

  def read_file_text(file_path)
    file = File.new(file_path, 'r')
    questions = []
    while line = file.gets
      puts "#{line}"
      # tách câu hỏi ra
      # tách các câu trả lời ra
      curr_question = {
        question: "",
        answers: {
          answer: "",
          is_correct: false
        }
      }
      questions << curr_question
    end
    questions
  end

end
