class ProductsController < ApplicationController

  def index
    @products = Product.all.order(created_at: :desc)
  end

  def show
    @product = Product.find params[:id]
    # Logic to Disable Add Button if quantity is 0
    @can_add_to_cart = @product.quantity > 0
  end

end
