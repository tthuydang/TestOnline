class Guest::HistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :shared_pages

  def index
    History.where(:completed_time => nil).destroy_all
    @histories = History.where(user_id: current_user.id).order(updated_at: :desc)
  end
end
