class RedWidgetHalfPrice
  PRODUCT_CODE = "R01"

  def apply(items, current_total)
    red_widgets = items.select { |item| item.code == PRODUCT_CODE }
    return current_total if red_widgets.size < 2

    eligible_pairs = red_widgets.size / 2
    unit_price = red_widgets.first.price

    half_price = (unit_price / 2.0).round(2)
    discount = eligible_pairs * half_price

    (current_total - discount).round(2)
  end
end
