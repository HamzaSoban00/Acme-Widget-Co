require 'stringio'
require_relative '../lib/cli'
require_relative '../lib/product'
require_relative '../lib/basket'
require_relative '../lib/offer/red_widget_half_price'
require_relative '../lib/delivery_rules'
require_relative '../lib/ui/icons'

RSpec.describe AcmeCLI do
  let(:catalog) do
    {
      "R01" => Product.new(code: "R01", name: "Red Widget", price: 32.95),
      "G01" => Product.new(code: "G01", name: "Green Widget", price: 24.95),
      "B01" => Product.new(code: "B01", name: "Blue Widget", price: 7.95)
    }
  end

  let(:offers) { [RedWidgetHalfPrice.new] }
  let(:delivery_rules) { DeliveryRules.default }

  def run_cli_with_input(input_lines)
    input = StringIO.new(input_lines.join("\n") + "\n")
    output = StringIO.new
    basket = Basket.new(products: catalog, offers: offers, delivery_rules: delivery_rules)

    cli = AcmeCLI.new(basket: basket, catalog: catalog, input: input, output: output)
    cli.start

    output.rewind
    output.read
  end

  it "adds items and shows final total" do
    output = run_cli_with_input(["R01", "G01", "done"])
    expect(output).to include("#{Icons[:success]} Added R01")
    expect(output).to include("#{Icons[:money]} Total: $60.85")
  end

  it "removes an item and reflects correct totals" do
    output = run_cli_with_input(["R01", "REMOVE R01", "done"])
    expect(output).to include("#{Icons[:delete]} Removed Red Widget (R01)")
    expect(output).to include("Total items: 0")
    expect(output).to include("💰 Total: $0.00")
  end

  it "shows an error for invalid product code" do
    output = run_cli_with_input(["XYZ", "done"])
    expect(output).to include("#{Icons[:warning]} Invalid product code: XYZ")
  end

  it "shows an error if REMOVE is used without a code" do
    output = run_cli_with_input(["REMOVE", "done"])
    expect(output).to include("#{Icons[:warning]} No product code given to remove.")
  end

  it "warns if trying to remove an item not in the basket" do
    output = run_cli_with_input(["REMOVE R01", "done"])
    expect(output).to include("#{Icons[:warning]} No item found with code: R01")
  end

  it "ignores empty input safely" do
    output = run_cli_with_input(["", "done"])
    expect(output).to include("Final Basket Summary:")
  end
end
