class DepositsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio
  before_action :set_coins, only: [:new]

  def new; end

  def create
    # debugger
    if deposit_params[:coin_id].blank?
      set_coins
      flash.now[:alert] = "Select a valid coin"
      return render :new, status: :unprocessable_entity
    end

    @holding = Holding.find_by(portfolio: @portfolio, coin_id: deposit_params[:coin_id])
    @holding.deposit(deposit_params[:amount].to_d)
    @holding.save
    redirect_to portfolio_path(@portfolio), notice: "Successfully deposited #{deposit_params[:amount].to_d} #{@holding.coin.ticker}"
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def set_coins
    @coins = @portfolio.holdings.map { |h| h.coin }
  end

  def deposit_params
    params.require(:deposit).permit(:coin_id, :amount, :portfolio_id)
  end
end
