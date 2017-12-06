require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "購物車基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了" do
    cart = Cart.new
    cart.add_item 1
    expect(cart.empty?).to be false
  end

    it "如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      cart = Cart.new
      3.times { cart.add_item(1) }
      5.times { cart.add_item(2) }
      2.times { cart.add_item(3) }

      expect(cart.items.length).to be 3
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.second.quantity).to be 5
    end

    it "商品可以放到購物車裡，也可以再拿出來" do
      cart = Cart.new
      p1 = Product.create(title:"七龍珠")               # 建立商品 1
      p2 = Product.create(title:"冒險野郎")             # 建立商品 2

      4.times { cart.add_item(p1.id) }                 # 放了 4 次的商品 1
      2.times { cart.add_item(p2.id) }                 # 放了 2 次的商品 2

      expect(cart.items.first.product_id).to be p1.id  # 第 1 個 item 的商品 id 應該會等於商品 1 的 id
      expect(cart.items.second.product_id).to be p2.id # 第 2 個 item 的商品 id 應該會等於商品 2 的 id
      expect(cart.items.first.product).to be_a Product # 第 1 個 item 拿出來的東西應該是一種商品
    end

    it "每個 Cart Item 都可以計算它自己的金額（小計）" do
      p1 = Product.create(title:"七龍珠", price: 80)      # 建立商品 1
      p2 = Product.create(title:"冒險野郎", price: 200)   # 建立商品 2

      cart = Cart.new
      3.times { cart.add_item(p1.id) }                   # 加 3 次商品 1
      4.times { cart.add_item(p2.id) }                   # 加 4 次商品 2
      2.times { cart.add_item(p1.id) }                   # 再加 2 次商品 1

      expect(cart.items.first.price).to be 400           # 第 1 條 cart item 的價錢應該是 400 塊
      expect(cart.items.second.price).to be 800          # 第 2 條 cart item 應該是 800 塊
    end

    it "可以計算整台購物車的總消費金額" do
      cart = Cart.new
      p1 = Product.create(title:"七龍珠", price: 80)      # 建立商品 1
      p2 = Product.create(title:"冒險野郎", price: 200)   # 建立商品 2

      3.times {
        cart.add_item(p1.id)
        cart.add_item(p2.id)
      }

      expect(cart.total_price).to be 840
    end

    it "特別活動可能可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百）" do
      
    end
  end

  describe "購物車進階功能" do
    it "可以將購物車內容轉換成 Hash，存到 Session 裡" do
      cart = Cart.new
      3.times { cart.add_item(2) }   # 新增商品 id 2
      4.times { cart.add_item(5) }   # 新增商品 id 5

      expect(cart.serialize).to eq session_hash
    end

    it "可以把 Session 的內容（Hash 格式），還原成購物車的內容" do
      cart = Cart.from_hash(session_hash)

      expect(cart.items.first.product_id).to be 2
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.second.product_id).to be 5
      expect(cart.items.second.quantity).to be 4
    end
  end

  private
  def session_hash
    {
      "items" => [
        {"product_id" => 2, "quantity" => 3},
        {"product_id" => 5, "quantity" => 4}
      ]
    }
  end
end
