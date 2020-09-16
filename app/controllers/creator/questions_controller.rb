class Creator::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :shared_pages
  before_action :check_if_creator

  def index
    redirect_to tickets_path if params[:ticket_code] == nil
    @ticket = Ticket.where(code: params[:ticket_code]).first
    @questions = Question.where(ticket_id: @ticket.id)
  end

  def importfile # custom action
    begin
      file_path = question_file_param[:file_question].path
      questions = file_path != nil ? get_questions_from_file_text(file_path) : nil

      # xóa hết question cũ, rồi save_to_database
      Question.where(:ticket_id => question_file_param[:ticket_id]).destroy_all
      save_to_database(questions, question_file_param[:ticket_id])

      flash[:notice] = "File successfully imported."
      redirect_back(fallback_location: questions_path) # load lại trang và giữ nguyên parameter trên url
    rescue => exception
      flash[:notice] = "File import failed."
      redirect_back(fallback_location: questions_path) # load lại trang và giữ nguyên parameter trên url
    end
  end

  def destroy
    begin
      question = Question.find(params[:id])
      question.destroy
    rescue => exception
      flash[:notice] = "Cannot destroy this question."
    end
    redirect_back(fallback_location: questions_path) # load lại trang và giữ nguyên parameter trên url
  end

  private

  def question_file_param # dùng riêng cho import file
    params.require(:question).permit(:file_question, :ticket_id)
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
    file = File.new(file_path, 'r')
    questions = []
    is_question = true
    i = 0
    while line = file.gets
      if line.strip.length > 0
        quest = line.match(/[Q]\s\d+[\.\:\/\)]/)    # Q 94.:/)
        ans = line.match(/^\w[\.\:\/\)]/)  # a.:/) hoặc A.:/) hoặc 1.:/)

        if quest != nil  # question
          curr_question = Question.new
          curr_question.question = line[(quest.to_s.length)..(-1)].strip
          curr_question.dsAnswers = []

          questions << curr_question
          i += 1
          is_question = true
        elsif ans != nil  # answer
          s_correct = line.match(/!!!T$/)    # !!!T
          ans_content = s_correct == nil ? line[(ans.to_s.length)..(-1)].strip : line[(ans.to_s.length)..(-1)].delete("!!!T").strip

          curr_answer = Answer.new
          curr_answer.answer = ans_content
          curr_answer.is_correct = s_correct == nil ? false : true
          questions[i - 1].dsAnswers << curr_answer

          is_question = false
        else  # dòng xuống hàng của question hoặc answer
          if is_question  # nối vào question
            questions[i - 1].question += " #{line.strip}"
          else  # nối vào answer
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
