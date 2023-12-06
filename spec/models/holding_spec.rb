require "rails_helper"

RSpec.describe Holding, type: :model do
  describe "#valid?" do
    it "false when amount less than 0" do
      holding = Holding.new(amount: -1)

      expect(holding.valid?).to be false
      expect(holding.errors.include?(:amount)).to be true
    end

    it "true when amount equals to 0" do
      holding = Holding.new(amount: 0)

      holding.valid?

      expect(holding.errors.include?(:amount)).to be false
    end

    it "true with no amount specified in constructor" do
      holding = Holding.new

      holding.valid?

      expect(holding.errors.include?(:amount)).to be false
    end

    it "false when coin is not unique in portfolio" do
      btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
      user = User.create!(email: "user@email.com", password: "123456")
      portfolio = Portfolio.create!(account: user.account, name: "Tests Portfolio")
      btc_holding = portfolio.holdings.create!(coin: btc, amount: 1.5)
      invalid_holding = portfolio.holdings.build(coin: btc, amount: 0.5)

      expect(invalid_holding.valid?).to be false
      expect(invalid_holding.errors.include?(:coin)).to be true
      expect(portfolio.holdings.count).to eq 1
      expect(portfolio.holdings.first.amount).to eq 1.5
    end
  end

  describe "#ticker" do
    it "returns the associated Coin's ticker" do
      coin = Coin.create!(name: "Test Coin", api_id: "test", ticker: "TST")
      holding = Holding.new(coin: coin)

      expect(holding.ticker).to eq "TST"
    end
  end
end
