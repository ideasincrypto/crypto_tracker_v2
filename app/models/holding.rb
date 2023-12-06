class Holding < ApplicationRecord
  belongs_to :coin
  belongs_to :portfolio

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  delegate :ticker, to: :coin
end
