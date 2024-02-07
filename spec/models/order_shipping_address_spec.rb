require 'rails_helper'

RSpec.describe OrderShippingAddress, type: :model do
  before do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    @order_shipping_address = FactoryBot.build(:order_shipping_address, user_id: user.id, item_id: item.id)
    sleep 0.1
  end

  describe '商品購入' do
    context '商品購入できる場合' do
      it '全ての項目が入力されていれば購入できる' do
        expect(@order_shipping_address).to be_valid
      end
      it 'buildingカラムは空でも購入できる' do
        @order_shipping_address.building = ''
        expect(@order_shipping_address).to be_valid
      end
    end

    context '商品購入できない場合' do
      it '郵便番号が空だと購入できない' do
        @order_shipping_address.post_code = ''
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include("Post code can't be blank")
      end

      it '郵便番号にハイフンを含む正しい形式でないと購入できない' do
        @order_shipping_address.post_code = '1234567'
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include('Post code is invalid. Include hyphen(-)')
      end

      it '都道府県選択されていないと購入できない' do
        @order_shipping_address.prefecture_id = 0
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include("Prefecture can't be blank")
      end

      it '市区町村が空だと購入できない' do
        @order_shipping_address.city = ''
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include("City can't be blank")
      end

      it '番地が空だと購入できない' do
        @order_shipping_address.address = ''
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include("Address can't be blank")
      end

      it '電話番号が空だと購入できない' do
        @order_shipping_address.phone_number = ''
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include("Phone number can't be blank")
      end

      it '電話番号に数字以外が含まれていると購入できない' do
        @order_shipping_address.phone_number = '090-0000-1234'
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include('Phone number 10桁または11桁の数字で入力してください')
      end

      it '電話番号が10桁未満だと購入できない' do
        @order_shipping_address.phone_number = '012345678'
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include('Phone number 10桁または11桁の数字で入力してください')
      end

      it '電話番号が12桁以上だと購入できない' do
        @order_shipping_address.phone_number = '012345678910'
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include('Phone number 10桁または11桁の数字で入力してください')
      end

      it 'tokenが空だと購入できない' do
        @order_shipping_address.token = ''
        @order_shipping_address.valid?
        expect(@order_shipping_address.errors.full_messages).to include("Token can't be blank")
      end
    end
  end
end
