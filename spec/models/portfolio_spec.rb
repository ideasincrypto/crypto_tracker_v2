require "rails_helper"

RSpec.describe Portfolio, type: :model do
  describe "#valid?" do
    it "false without name" do
      portfolio = Portfolio.new(name: "")

      expect(portfolio.valid?).to be false
      expect(portfolio.errors.include?(:name)).to be true
    end
  end

  describe "#total_value" do
    it "calculates the total value in USD of a portfolio" do
      coin_a = Coin.create!(name: "Coin A", api_id: "coin_a", ticker: "COINA", rate: 10)
      coin_b = Coin.create!(name: "Coin B", api_id: "coin_b", ticker: "COINB", rate: 20)
      coin_c = Coin.create!(name: "Coin C", api_id: "coin_C", ticker: "COINC", rate: 30)
      user = User.create!(email: "user@email.com", password: "123456")
      portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
      portfolio.holdings.create!([{ coin: coin_a, amount: 1 },
                                  { coin: coin_b, amount: 1 },
                                  { coin: coin_c, amount: 1 }])

      expect(portfolio.total_value).to eq 60.0
    end

    it "returns zero if the portfolio is empty" do
      user = User.create!(email: "user@email.com", password: "123456")
      portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")

      expect(portfolio.total_value).to eq 0.0
    end
  end
end
