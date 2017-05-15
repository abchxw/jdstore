class ProductsController < ApplicationController
  def index
  #   if params[:category].blank?
  #     @products = Product
  #   else
  #     @category_id = Category.find_by(name:params[:category]).id
  #     @products = Product.where(:category_id => @category_id).order("created_at DESC")
  #   end
  # @products = Product.all.recent
    if params[:category].present?
      @products = Product.all.where(category_id: params[:category]).recent
    else
      @products = Product.all.recent
    end
  end

  def show
    @product = Product.find(params[:id])
    @photos = @product.photos.all
  end

  def add_to_cart
     @product = Product.find(params[:id])
     if !current_cart.products.include?(@product)
     current_cart.add_product_to_cart(@product)
     flash[:notice] = "你已成功将 #{@product.title} 加入购物车"
    else
      flash[:warning] = "你的购物车内已有此物品"
    end
     redirect_to :back
   end

   def update
    @product = Product.find(params[:id])

    if params[:photos] != nil
      @product.photos.destroy_all #need to destroy old pics first

      params[:photos]['avatar'].each do |a|
        @picture = @product.photos.create(:avatar => a)
      end

      @product.update(product_params)
      redirect_to admin_products_path

    elsif @product.update(product_params)
      redirect_to admin_products_path
    else
      render :edit
    end
  end


end
