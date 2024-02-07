class OrdersController < ApplicationController
  before_action :set_item, only: [:index, :create]
  def index
    @order_shipping_address = OrderShippingAddress.new
  end

  def create
    @order_shipping_address = OrderShippingAddress.new(order_params)
    if @order_shipping_address.valid?
      @order_shipping_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order_shipping_address).permit(
      :post_code,
      :prefecture_id,
      :city,
      :address,
      :building,
      :phone_number
      ).merge(item_id: @item.id, user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end
end
