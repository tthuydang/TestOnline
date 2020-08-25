class SubticketsController < ApplicationController
  def check_creator
    if current_user == nil
      redirect_to root_path
    end
  end

  def index
    @subticket = @subticket.find[:id]
  end
end
