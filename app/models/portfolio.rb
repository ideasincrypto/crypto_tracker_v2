class Portfolio < ApplicationRecord
  belongs_to :account
  has_many :holdings

  validates :name, presence: true
end
