class Coin < ApplicationRecord
  has_many :holdings

  validates :name, :api_id, :ticker, presence: true
  validates :name, :api_id, :ticker, uniqueness: true
  validates :rate, numericality: { greater_than_or_equal_to: 0 }

  def set_rate(request_service)
    # debugger
    json_response = request_service.get_rates(self)
    self.update(rate: json_response.dig(api_id.to_sym, :usd))
  end
end
