require "json"
require "fileutils"

class Creator::SubticketsController < ApplicationController
  before_action :authenticate_user!
  before_action :shared_pages
  before_action :check_if_creator

  def index
    @subtickets = []
    Ticket.where(user_id: current_user.id).each do |t|
      t.subtickets.each do |s|
        @subtickets << s
      end
    end
  end

  def show
    @content = JSON.parse(Subticket.find(params[:id]).content)
  end

  def new
    @subticket = Subticket.new
    @ticket = Ticket.where(code: params[:code]).first
  end

  def create
    Ticket.where(:id => subticket_params[:ticket_id], :user_id => current_user.id).first.subtickets.destroy_all
    ticket = Ticket.find(subticket_params[:ticket_id])
    code = ticket.code
    for i in 1..amount_param[:amount].to_i
      break if i > amount_param[:amount].to_i
      subticket = Subticket.new(subticket_params)
      subticket.result_ques = subticket_params[:result_ques] == "1" ? true : false
      subticket.result_ans = subticket_params[:result_ans] == "1" ? true : false
      subticket.code = "#{code}-#{ticket.subtickets.count}"
      subticket.content = save_subticket_content(ticket, subticket.result_ques, subticket.result_ans)
      subticket.save
    end
    @subtickets = Subticket.all
    render :index
  end

  def destroy
    @subticket = Subticket.find(params[:id])
    @subticket.destroy
    flash[:notice] = "Subticket successfully deleted."
    redirect_to subtickets_path
  end

  def view_subticket
    @subtickets = Subticket.all.where(ticket_id: subticket_params[:ticket_id])
  end

  def download_subticket
    subticket = Subticket.find(params[:subticket_id])
    ques = subticket.ticket.questions
    result_ques = subticket.result_ques
    result_ans = subticket.result_ans

    write_ques_ans_to_public(ques, subticket, result_ques, result_ans)

    flash[:notice] = "Subticket download successfully. Please check at Downloads directory!"

    redirect_back(fallback_location: subtickets_path)
  end

  private

  def subticket_params
    params.require(:subticket).permit(:code, :ticket_id, :result_ques, :result_ans, :content)
  end

  def amount_param
    params.require(:subticket).permit(:amount)
  end

  def save_subticket_content(ticket, shuffle_ques, shuffle_ans)
    content = []
    ticket.questions.shuffle.each do |quest|
      data = []
      data << quest.id
      answers = shuffle_ans == true ? quest.answers.shuffle : quest.answers

      ans = []
      answers.each { |an| ans << an.id }
      data << ans
      content << data
    end
    content.to_s
  end

  def write_ques_ans_to_public(ques, subticket, result_ques, result_ans)
    path = "#{Dir.home}/Downloads/#{subticket.code}"
    FileUtils.mkdir_p path

    f1 = File.open("#{path}/#{subticket.code}-Question.doc", "w+")
    f2 = File.open("#{path}/#{subticket.code}-Ans.doc", "w+")

    f1.puts("#{subticket.code}")
    f2.puts("#{subticket.code} --ANSWERS --")
    if result_ques == true
      ques = ques.shuffle
    end
    ques.each_with_index do |q, i|
      f1.puts ""
      f2.puts ""
      f1.puts("Question #{i + 1}: #{q.question}")
      f2.puts("Question #{i + 1}: #{q.question}")
      if result_ans == true
        q.answers.shuffle.each_with_index do |a, k|
          f1.puts("A#{k + 1}: #{a.answer}")
          if a.is_correct == true
            f2.puts("A#{k + 1}: #{a.answer}" + "--|True|--")
          else
            f2.puts("A#{k + 1}: #{a.answer}")
          end
        end
      else
        q.answers.each_with_index do |a, k|
          f1.puts("A#{k + 1}: #{a.answer}")
          if a.is_correct == true
            f2.puts("A#{k + 1}: #{a.answer}" + "--|True|--")
          else
            f2.puts("A#{k + 1}: #{a.answer}")
          end
        end
      end
    end

    f1.close
    f2.close
  end
end
