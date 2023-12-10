class Portfolio < ApplicationRecord
  belongs_to :account
  has_many :holdings
  has_many :coins, through: :holdings

  validates :name, presence: true
end
