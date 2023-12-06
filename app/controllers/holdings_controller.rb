class HoldingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio, only: [:new, :create]
  before_action :set_coin, only: [:create]

  def new
    @holding = Holding.new
    @coins = Coin.where(enabled: true)
  end

  def create
    @holding = @portfolio.holdings.build(holding_params)
    @holding.save
    redirect_to @portfolio, notice: "#{@coin.ticker} added to Portfolio"
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def holding_params
    params.require(:holding).permit(:coin_id, :amount)
  end

  def set_coin
    @coin = Coin.find(params.dig(:holding, :coin_id))
  end

end
