class Coin < ApplicationRecord
  has_many :holdings

  validates :name, :api_id, :ticker, presence: true
end
