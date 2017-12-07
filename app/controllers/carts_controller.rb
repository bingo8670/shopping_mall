class CartsController < ApplicationController
  def add
    cart = Cart.from_hash(session[:cart9487])
    cart.add_item(params[:id])
    session[:cart9487] = cart.serialize

    redirect_to product_path, notice: "已加入购物车"
  end
end
