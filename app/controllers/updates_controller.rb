class UpdatesController < ApplicationController
  before_action :set_portfolio, only: [:new, :create]
  before_action :set_coins, only: [:new, :create]


  def new; end

  def create
    # debugger
    @holding = Holding.where(portfolio_id: update_params[:portfolio_id], coin_id: update_params[:coin_id])
    @holding.update!(amount: update_params[:amount].to_d)
    redirect_to @portfolio, success: "#{update_params[:coin_id]} updated successfully"
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def set_coins
    @coins = @portfolio.holdings.map { |h| h.coin }
  end

  def update_params
    params.require(:update).permit(:coin_id, :amount, :portfolio_id)
  end
end
