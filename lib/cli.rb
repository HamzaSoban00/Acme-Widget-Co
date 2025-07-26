require_relative 'ui/icons'

class AcmeCLI
  def initialize(basket:, catalog:, input: $stdin, output: $stdout, fancy: false)
    @basket = basket
    @catalog = catalog
    @input = input
    @output = output
    @fancy = fancy
    @messages = []
  end

  def start
    loop do
      refresh_screen

      output.print colorize("> ", :prompt)
      line = input.gets&.strip
      break if line.nil? || line.downcase == 'done'

      handle_command(line)
    end

    refresh_screen("#{Icons[:receipt]} Final Basket Summary:")
  end

  private

  attr_reader :basket, :input, :output, :catalog, :fancy, :messages

  def handle_command(line)
    command, arg = line.strip.split
    command = command&.upcase
    arg = arg&.upcase

    if command == "REMOVE" || command == "R"
      raise "No product code given to remove." if arg.nil?

      removed = basket.remove(arg)
      messages << "#{Icons[:delete]} Removed #{removed.name} (#{removed.code})"
    else
      basket.add(command)
      messages << "#{Icons[:success]} Added #{command}"
    end
  rescue => e
    messages << "#{Icons[:warning]} #{e.message}"
  end

  def refresh_screen(title = "#{Icons[:basket]} Cart Overview:")
    clear_screen
    print_header
    render_summary(title)
  end

  def print_header
    output.puts colorize("#{Icons[:cart]} Welcome to Acme Widget Co", :header)
    output.puts "Available products:"
    catalog.each do |code, product|
      output.puts "- #{product.name} (#{code}): $#{'%.2f' % product.price}"
    end
    output.puts "\nEnter product codes to ADD (e.g., R01), or type 'REMOVE R01' to remove an item."
    output.puts "Type 'done' when finished:\n"
  end

  def render_summary(title)
    output.puts colorize("\n#{title}", :title)

    if basket.items.empty?
      output.puts "(no items in cart)"
    else
      basket.grouped_items.each do |code, products|
        p = products.first
        output.puts "- #{p.name} (#{code}) x#{products.count}: $#{'%.2f' % (p.price * products.count)}"
      end
    end

    output.puts "Total items: #{basket.items.size}"
    output.puts "Subtotal: $#{'%.2f' % basket.subtotal}"
    output.puts "Discounted Subtotal: $#{'%.2f' % basket.discounted_subtotal}"
    output.puts "Delivery: $#{'%.2f' % basket.delivery}"
    output.puts colorize("#{Icons[:money]} Total: $#{'%.2f' % basket.total}", :highlight)
    output.puts "---------------------------"

    messages.each { |msg| output.puts colorize(msg, :info) }
    messages.clear
  end

  def clear_screen
    output.print "\e[H\e[2J" if fancy
  end

  def colorize(text, type)
    return text unless fancy

    case type
    when :header      then "\e[1;36m#{text}\e[0m"  # Cyan bold
    when :title       then "\e[1;33m#{text}\e[0m"  # Yellow bold
    when :highlight   then "\e[1;32m#{text}\e[0m"  # Green bold
    when :warning     then "\e[1;31m#{text}\e[0m"  # Red
    when :prompt      then "\e[1;35m#{text}\e[0m"  # Magenta
    when :info        then "\e[0;37m#{text}\e[0m"  # Gray
    else text
    end
  end
end
