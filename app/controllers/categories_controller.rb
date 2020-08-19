class CategoriesController < ApplicationController

  def index
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if category_params[:title].strip == '' || Category.find_by_title(category_params[:title]).present?
      render new_category_path
    else
      @category.save
      redirect_to categories_path
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
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:title, :image, :user_id)
  end

end
