class HoldingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio, only: [:new, :create]
  before_action :set_coin, only: [:create]
  before_action :set_coins, only: [:new]


  def new
    @holding = Holding.new
  end

  def create
    # debugger
    @holding = @portfolio.holdings.build(holding_params)
    if @holding.save
      redirect_to @portfolio, notice: "#{@coin.ticker} added to Portfolio"
    else
      set_coins
      render :new
    end
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

  def set_coins
    @coins = Coin.where(enabled: true)
  end

end
