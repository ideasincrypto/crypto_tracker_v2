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

  describe ".load_coins" do
    it "saves list of supported coins to database" do
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      json_contract = File.read(Rails.root.join("spec/support/json/markets_contract.json"))
      fake_response = double("res", status: 200, body: json_contract)

      allow(conn).to receive(:get).with("api/v3/coins/markets").and_return(fake_response)
      Coin.load_coins(request_service)

      expect(Coin.all.count).to eq 3
      expect(Coin.first.name).to eq "Bitcoin"
      expect(Coin.first.api_id).to eq "bitcoin"
      expect(Coin.first.ticker).to eq "BTC"
      expect(Coin.first.rate).to eq 41177.06
      expect(Coin.first.icon).to eq "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"
      expect(Coin.second.name).to eq "Ethereum"
      expect(Coin.second.api_id).to eq "ethereum"
      expect(Coin.second.ticker).to eq "ETH"
      expect(Coin.second.rate).to eq 2216.18
      expect(Coin.second.icon).to eq "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1696501628"
      expect(Coin.third.name).to eq "Cardano"
      expect(Coin.third.api_id).to eq "cardano"
      expect(Coin.third.ticker).to eq "ADA"
      expect(Coin.third.rate).to eq 0.55
      expect(Coin.third.icon).to eq "https://assets.coingecko.com/coins/images/975/large/cardano.png?1696502090"
    end

    it "doesn't save repeated coins" do
      btc = Coin.create!(
        name: "Bitcoin",
        api_id: "bitcoin",
        ticker: "BTC",
        icon: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        rate: 41177.07
      )
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      json_contract = File.read(Rails.root.join("spec/support/json/markets_contract.json"))
      fake_response = double("res", status: 200, body: json_contract)

      allow(conn).to receive(:get).with("api/v3/coins/markets").and_return(fake_response)
      Coin.load_coins(request_service)

      expect(Coin.all.count).to eq 3
    end
  end
end
