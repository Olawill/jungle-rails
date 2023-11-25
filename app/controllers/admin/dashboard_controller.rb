class Admin::DashboardController < ApplicationController
  http_basic_authenticate_with name: ENV['AUTH_USERNAME'], password: ENV['AUTH_PASSWORD']

  def show
    product_count = Product.count
    category_count = Category.count
    low_stock = Product.where('quantity = 0').count
    total_order = Order.count

    @data_hash = {
      product_count: product_count,
      category_count: category_count,
      low_stock: low_stock,
      total_order: total_order
    }
  end
end
