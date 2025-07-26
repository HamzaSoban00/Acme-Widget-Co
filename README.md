# 🛒 Acme Basket CLI

A test-driven Ruby command-line application that simulates a shopping basket. Includes dynamic offers, tiered delivery pricing, and an optional interactive **fancy UI** with emoji feedback and live cart updates.

---

## 📦 Features

- Add or remove products by code
- Automatically applies available offers (e.g., Buy One Get One Half Price on R01)
- Tiered delivery fee logic based on subtotal
- Optional **fancy UI** with **live cart overview after each action**
- Fully tested with RSpec

---

## 💡 Precision Assumption

- When applying offers, we truncate to 2 decimal places without rounding.
- For example:
  ```bash
  32.95 / 2 = 16.475 → becomes 16.47 (not 16.48)

---

## 🧰 Prerequisites

- Ruby 2.7 or higher
- Bundler (`gem install bundler`)

---

## 🔧 Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/HamzaSoban00/Acme-Widget-Co.git
   cd Acme-Widget-Co

2. Install dependencies:
   ```bash
   bundle install

---

## 🚀 Running the App

- Basic CLI
  ```bash
  ruby main.rb

- Fancy UI Mode (with live cart overview)
  ```bash
  ruby main.rb --fancy-ui

---

## 🧪 Running Tests
  ```bash
  bundle exec rspec
