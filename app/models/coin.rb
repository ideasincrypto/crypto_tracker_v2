class Coin < ApplicationRecord
  validates :name, :api_id, :ticker, presence: true
end
