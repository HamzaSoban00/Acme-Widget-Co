module Icons
  ICONS = {
    success: '✅',
    warning: '⚠️',
    delete:  '🗑️',
    cart:    '🛒',
    receipt: '🧾',
    basket:  '🧺',
    money:   '💰'
  }

  def self.[](key)
    ICONS[key] || ''
  end
end
