class CartsController < ApplicationController
  def add
    current_cart.add_tiem(params[:id])
    session[:cart9487] = current_cart.serialize

    redirect_to product_path, notice: "已加入购物车"
  end

  def destroy
    session[:cart9487] = nil
    redirect_to products_path, notice: "购物车已清空"
  end
end
