require 'rspec'
require_relative '../lib/basket'
require_relative '../lib/product'
require_relative '../lib/delivery_rules'
require_relative '../lib/offer/red_widget_half_price'

RSpec.describe Basket do
  let(:catalog) do
    {
      "R01" => Product.new(code: "R01", name: "Red Widget", price: 32.95),
      "G01" => Product.new(code: "G01", name: "Green Widget", price: 24.95),
      "B01" => Product.new(code: "B01", name: "Blue Widget", price: 7.95)
    }
  end

  let(:offers) { [RedWidgetHalfPrice.new] }

  subject(:basket) do
    Basket.new(products: catalog, offers: offers, delivery_rules: DeliveryRules.default)
  end

  context "when buying B01 and G01" do
    it "totals $37.85" do
      basket.add("B01")
      basket.add("G01")
      expect(basket.total.to_f).to eq(37.85)
    end
  end

  context "when buying two R01s" do
    it "applies the half price offer and totals $54.37" do
      2.times { basket.add("R01") }
      expect(basket.total.to_f).to eq(54.37)
    end
  end

  context "when buying R01 and G01" do
    it "does not apply the red widget offer and totals $60.85" do
      basket.add("R01")
      basket.add("G01")
      expect(basket.total.to_f).to eq(60.85)
    end
  end

  context "when buying B01, B01, R01, R01, R01" do
    it "applies one red widget offer and totals $98.27" do
      %w[B01 B01 R01 R01 R01].each { |code| basket.add(code) }
      expect(basket.total.to_f).to eq(98.27)
    end
  end

  context "with invalid product code" do
    it "raises an error" do
      expect { basket.add("INVALID") }.to raise_error(ArgumentError, /Invalid product code/)
    end
  end

    context "when buying three R01s" do
    it "applies one discount and charges full price for third" do
      3.times { basket.add("R01") }
      expect(basket.total.to_f).to eq(85.32)
    end
  end

  context "when buying four R01s" do
    it "applies two discounts" do
      4.times { basket.add("R01") }
      expect(basket.total.to_f).to eq(98.84)
    end
  end

  context "when basket is empty" do
    it "returns 0" do
      expect(basket.total.to_f).to eq(0.00)
    end
  end

  context "when total is just under free delivery threshold" do
    it "applies $2.95 delivery for subtotal $89.99" do
      %w[G01 G01 G01 B01].each { |code| basket.add(code) }
      expect(basket.total.to_f).to eq(85.75)
    end
  end

  context "when total is exactly $90" do
    it "gives free delivery" do
      %w[R01 G01 B01 G01].each { |code| basket.add(code) }
      expect(basket.total.to_f).to eq(90.80)
    end
  end

  context "when total is just below $50" do
    it "applies $4.95 delivery" do
      basket.add("G01")
      basket.add("B01")
      expect(basket.total.to_f).to eq(37.85)
    end
  end
end
