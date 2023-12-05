class HoldingsController < ApplicationController
  before_action :set_coin, only: [:create]

  def new
    @holding = Holding.new
    @coins = Coin.where(enabled: true)
  end

  def create
    @holding = Holding.new(holding_params)

    @holding.save

    redirect_to root_path, notice: "#{@coin.ticker} added to Portfolio"
  end

  private

  def holding_params
    params.require(:holding).permit(:coin_id, :amount)
  end

  def set_coin
    @coin = Coin.find(params.dig(:holding, :coin_id))
  end

end
