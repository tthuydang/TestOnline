class Guest::HistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :shared_pages

  def index
  end
end
