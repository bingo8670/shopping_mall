class ProductsController < ApplicationController
  before_action :find_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "新增商品完成"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "商品更新成功"
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find_by(id:params[:id])
    redirect_to products_path, notice: "无此商品" unless @product
  end

  private
  def product_params
    params.require(:product).permit(:title, :description, :price)
  end
end
