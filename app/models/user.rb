class User < ApplicationRecord
  has_one :account
  has_many :portfolios, through: :account

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_account

  private

  def create_account
    self.account ||= Account.new
  end
end
