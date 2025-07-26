class DeliveryRules
  def initialize(&block)
    @rules = []
    instance_eval(&block) if block_given?
  end

  def rule(threshold:, fee:)
    @rules << { threshold: threshold, fee: fee }
  end

  def calculate(subtotal)
    return 0.0 if subtotal <= 0
    rule = @rules.find { |r| subtotal < r[:threshold] }
    rule ? rule[:fee] : 0.0
  end

  def self.default
    new do
      rule threshold: 50, fee: 4.95
      rule threshold: 90, fee: 2.95
    end
  end
end
