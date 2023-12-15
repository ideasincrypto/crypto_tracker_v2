class Portfolio < ApplicationRecord
  belongs_to :account
  has_many :holdings
  has_many :coins, through: :holdings

  validates :name, presence: true

  def refresh_rates(request_service)
    return if holdings.empty?

    coins = self.coins
    rates = request_service.get_rates(coins)
    coins.each do |coin|
      rate = rates.dig(coin.api_id.to_sym, :usd)
      coin.update!(rate: rate)
    end
  end

  def total_value
    holdings.reduce(0.0) do |total, holding|
      total += holding.amount * holding.coin.rate
      total
    end.round(2)
  end
end
