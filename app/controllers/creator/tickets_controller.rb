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
    begin
      @ticket = Ticket.new(ticket_params)
      @ticket.user_id = current_user.id

      if @ticket.save
        if file_param[:file_question] # nếu có import file txt thì save danh sách câu hỏi
          questions = get_questions_from_file_text(file_param[:file_question].path)
          save_to_database(questions, @ticket.id) if questions != nil
        end
        flash[:notice] = "Ticket successfully created."
        redirect_to tickets_path
      else
        render :new
      end
    rescue => exception
      render :new
    ensure
    end
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    begin
      @ticket = Ticket.find(params[:id])
      if @ticket.update(ticket_params)
        if file_param[:file_question] # nếu có import file txt thì update lại danh sách câu hỏi
          questions = get_questions_from_file_text(file_param[:file_question].path)

          # xóa hết question cũ, rồi save_to_database
          Question.where(:ticket_id => @ticket.id).destroy_all
          save_to_database(questions, @ticket.id) if questions != nil
        end

        flash[:notice] = "Ticket successfully updated."
        redirect_to tickets_path
      else
        render :edit
      end
    rescue => exception
      render :new
    ensure
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    flash[:notice] = "Subticket successfully deleted."
    redirect_to tickets_path
  end

  private

  def ticket_params
    params.require(:ticket).permit(:code, :title, :image, :description, :max_time, :category_id)
  end

  def file_param
    params.require(:ticket).permit(:file_question)
  end

  def save_to_database(questions, ticket_id)
    questions.each do |quest|
      curr_question = Question.new
      curr_question.question = quest.question
      curr_question.ticket_id = ticket_id
      curr_question.save

      quest.dsAnswers.each do |ans|
        curr_answer = Answer.new
        curr_answer.answer = ans.answer
        curr_answer.is_correct = ans.is_correct
        curr_answer.question_id = curr_question.id
        curr_answer.save
      end
    end
  end

  # lấy danh sách question & answer
  def get_questions_from_file_text(file_path)
    file = File.new(file_path, "r")
    questions = []
    is_question = true
    i = 0
    while line = file.gets
      if line.strip.length > 0
        quest = line.match(/[Q]\s\d{1,999}[\.\:\/\)]/)    # Q 94.:/)
        ans = line.match(/^\w[\.\:\/\)]/)  # a.:/) hoặc A.:/) hoặc 1.:/)

        if quest != nil # question
          curr_question = Question.new
          curr_question.question = line[(quest.to_s.length)..(-1)].strip
          curr_question.dsAnswers = []

          questions << curr_question
          i += 1
          is_question = true
        elsif ans != nil # answer
          s_correct = line.match(/!!!T$/)    # !!!T
          ans_content = s_correct == nil ? line[(ans.to_s.length)..(-1)].strip : line[(ans.to_s.length)..(-1)].delete("!!!T").strip

          curr_answer = Answer.new
          curr_answer.answer = ans_content
          curr_answer.is_correct = s_correct == nil ? false : true
          questions[i - 1].dsAnswers << curr_answer

          is_question = false
        else # dòng xuống hàng của question hoặc answer
          if is_question # nối vào question
            questions[i - 1].question += " #{line.strip}"
          else # nối vào answer
            # nếu xuống hàng có !!!T
            s_correct = line.match(/!!!T$/)    # !!!T
            ans_content = s_correct == nil ? line.strip : line.delete("!!!T").strip

            # cập nhật lại is_correct và answer
            questions[i - 1].dsAnswers.last.is_correct = true if s_correct != nil
            questions[i - 1].dsAnswers.last.answer += " #{ans_content}"
          end
        end
      end
    end
    questions
  end
end
