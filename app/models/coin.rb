class Coin < ApplicationRecord
  has_many :holdings

  validates :name, :api_id, :ticker, presence: true
  validates :name, :api_id, :ticker, uniqueness: true
  validates :rate, numericality: { greater_than_or_equal_to: 0 }

  def self.load_coins(request_service)
    coins_data = request_service.get_coins_data
    coins_data.each do |c|
      Coin.find_or_create_by(
        name: c["name"],
        api_id: c["id"],
        ticker: c["symbol"].upcase,
        icon: c["image"],
        rate: c["current_price"]
      )
    end
  end

  def set_rate(request_service)
    json_response = request_service.get_rates(self)
    self.update(rate: json_response.dig(api_id.to_sym, :usd))
  end
end
