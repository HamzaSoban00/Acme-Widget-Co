class Basket
  attr_reader :items

  def initialize(products:, offers: [], delivery_rules:)
    @products = products
    @offers = offers
    @delivery_rules = delivery_rules
    @items = []
  end

  def add(product_code)
    product = @products[product_code]
    raise ArgumentError, "Invalid product code: #{product_code}" unless product

    @items << product
  end

  def remove(product_code)
    index = @items.rindex { |item| item.code == product_code }
    raise ArgumentError, "No item found with code: #{product_code}" unless index

    @items.delete_at(index)
  end

  def subtotal
    @items.sum(&:price)
  end

  def discounted_subtotal
    apply_offers(@items)
  end

  def delivery
    delivery_fee(discounted_subtotal)
  end

  def total
    (discounted_subtotal + delivery).round(2)
  end

  def grouped_items
    @items.group_by(&:code)
  end

  private

  def apply_offers(items)
    @offers.reduce(items.sum(&:price)) do |total, offer|
      offer.apply(items, total)
    end
  end

  def delivery_fee(subtotal)
    @delivery_rules.calculate(subtotal)
  end
end
