require_relative 'lib/product'
require_relative 'lib/basket'
require_relative 'lib/offer/red_widget_half_price'
require_relative 'lib/delivery_rules'
require_relative 'lib/cli'
require_relative 'lib/ui/icons'

PRODUCT_CATALOG = {
  "R01" => Product.new(code: "R01", name: "Red Widget", price: 32.95),
  "G01" => Product.new(code: "G01", name: "Green Widget", price: 24.95),
  "B01" => Product.new(code: "B01", name: "Blue Widget", price: 7.95)
}

basket = Basket.new(
  products: PRODUCT_CATALOG,
  offers: [RedWidgetHalfPrice.new],
  delivery_rules: DeliveryRules.default
)

fancy = ARGV.include?('--fancy-ui')

AcmeCLI.new( basket: basket, catalog: PRODUCT_CATALOG, fancy: fancy ).start
