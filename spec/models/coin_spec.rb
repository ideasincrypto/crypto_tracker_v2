require "rails_helper"

RSpec.describe Coin, type: :model do
  describe "#valid?" do
    it "false without name" do
      coin = Coin.new(name: "", api_id: "test_coin", ticker: "TST")

      expect(coin.valid?).to be false
      expect(coin.errors.include?(:name)).to be true
      expect(coin.errors.include?(:api_id)).to be false
      expect(coin.errors.include?(:ticker)).to be false
    end

    it "false without api id" do
      coin = Coin.new(name: "Test Coin", api_id: "", ticker: "TST")

      expect(coin.valid?).to be false
      expect(coin.errors.include?(:api_id)).to be true
      expect(coin.errors.include?(:name)).to be false
      expect(coin.errors.include?(:ticker)).to be false
    end

    it "false without ticker" do
      coin = Coin.new(name: "Test Coin", api_id: "test_coin", ticker: "")

      expect(coin.valid?).to be false
      expect(coin.errors.include?(:ticker)).to be true
      expect(coin.errors.include?(:name)).to be false
      expect(coin.errors.include?(:api_id)).to be false
    end
  end
end
