class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    raise ArgumentError, "Code must be a string" unless code.is_a?(String)
    raise ArgumentError, "Name must be a string" unless name.is_a?(String)
    raise ArgumentError, "Price must be numeric" unless price.is_a?(Numeric)

    @code = code.freeze
    @name = name.freeze
    @price = price.to_f.freeze
  end
end
