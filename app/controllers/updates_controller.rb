class UpdatesController < ApplicationController
  before_action :set_portfolio, only: [:new, :create]
  before_action :set_coins, only: [:new, :create]


  def new

  end

  def create
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def set_coins
    @coins = @portfolio.holdings.map { |h| h.coin }
  end
end
