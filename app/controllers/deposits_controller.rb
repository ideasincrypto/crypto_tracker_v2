class DepositsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio
  before_action :set_coins, only: [:new]

  def new; end

  def create
    # debugger
    return deposit_error_redirect("Select a valid coin") if deposit_params[:coin_id].blank?
    return deposit_error_redirect("Amount must be a positive number") unless deposit_params[:amount].to_d.positive?

    @holding = Holding.find_by(portfolio: @portfolio, coin_id: deposit_params[:coin_id])
    @holding.deposit(deposit_params[:amount].to_d)

    if @holding.save
      redirect_to portfolio_path(@portfolio), notice: "Successfully deposited #{deposit_params[:amount].to_d} #{@holding.coin.ticker}"
    end
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

  def deposit_error_redirect(message)
    set_coins
    flash.now[:alert] = message
    render :new, status: :unprocessable_entity
  end
end
