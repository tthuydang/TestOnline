class Creator::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :shared_pages
  before_action :check_if_creator

  def index
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    if @category.save
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.tickets.size == 0
      @category.destroy
      flash[:notice] = "Category successfully deleted."
    else
      flash[:notice] = "Cannot delete this category."
    end
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:title)
  end
end
