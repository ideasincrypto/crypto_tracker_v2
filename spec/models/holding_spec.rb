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
  end

  describe "#ticker" do
    it "returns the associated Coin's ticker" do
      coin = Coin.create!(name: "Test Coin", api_id: "test", ticker: "TST")
      holding = Holding.new(coin: coin)

      expect(holding.ticker).to eq "TST"
    end
  end
end
