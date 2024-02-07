class OrdersController < ApplicationController
  before_action :set_item, only: [:index, :create]
  before_action :set_public_key, only: [:index, :create]
  def index
    @order_shipping_address = OrderShippingAddress.new
  end

  def create
    @order_shipping_address = OrderShippingAddress.new(order_params)
    if @order_shipping_address.valid?
      pay_order
      @order_shipping_address.save
      redirect_to root_path
    else
      set_public_key
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
      ).merge(item_id: @item.id, user_id: current_user.id, token: params[:token])
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def pay_order
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
  end

  def set_public_key
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
  end
end
