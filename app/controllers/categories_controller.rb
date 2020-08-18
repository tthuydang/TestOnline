class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to new_category_path
  end

  private

  def category_params
    params.require(:category).permit(:title, :image)
  end

end
