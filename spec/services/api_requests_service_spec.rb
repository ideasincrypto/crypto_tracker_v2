require "rails_helper"

RSpec.describe ApiRequestsService, type: :model do
  describe "#get_rates" do
    it "return a hash of rates from the API" do
      btc = Coin.new(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
      eth = Coin.new(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
      ada = Coin.new(name: "Cardano", api_id: "cardano", ticker: "ADA")
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      json_contract = File.read(Rails.root.join("spec/support/json/rates_contract.json"))
      fake_response = double("res", status: 200, body: json_contract)

      allow(conn).to receive(:get).and_return(fake_response)
      rates = request_service.get_rates(btc, eth, ada)

      expect(rates).to be_a Hash
      expect(rates.keys).to include :bitcoin, :ethereum, :cardano
      expect(rates[:bitcoin]).to eq usd: 43841.49
      expect(rates[:ethereum]).to eq usd: 2344.74
      expect(rates[:cardano]).to eq usd: 0.59
    end
  end

  describe "#get_coins_data" do
    it "get coins from API" do
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      json_contract = File.read(Rails.root.join("spec/support/json/markets_contract.json"))
      fake_response = double("res", status: 200, body: json_contract)

      allow(conn).to receive(:get).with("api/v3/coins/markets").and_return fake_response
      data = request_service.get_coins_data

      expect(data).to be_a Array
      expect(data.first["id"]).to eq "bitcoin"
      expect(data.first["current_price"]).to eq 41177.06
      expect(data.second["id"]).to eq "ethereum"
      expect(data.second["current_price"]).to eq 2216.18
      expect(data.third["id"]).to eq "cardano"
      expect(data.third["current_price"]).to eq 0.55
    end

    it "raises ApiError with 503 status" do
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      fake_response = double("error", status: 503)

      allow(conn).to receive(:get).with("api/v3/coins/markets").and_return fake_response
      expect { request_service.get_coins_data }.to raise_error ApiError, "Service Unavailable"
    end

    it "raises ApiError with 500 status" do
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      fake_response = double("error", status: 500)

      allow(conn).to receive(:get).with("api/v3/coins/markets").and_return fake_response
      expect { request_service.get_coins_data }.to raise_error ApiError, "The API returned an error"
    end
  end
end
