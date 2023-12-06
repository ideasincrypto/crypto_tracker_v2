class WithdrawsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio, only: [:new, :create]
  before_action :set_coins, only: [:new]

  def new; end

  def create
    # debugger
    @holding = Holding.find_by(portfolio_id: @portfolio.id, coin_id: withdraw_params[:coin_id])

    return witdhraw_error_redirect("Not enough funds to withdraw") if withdraw_params[:amount].to_d > @holding.amount

    @holding.withdraw(withdraw_params[:amount].to_d)

    if @holding.save
      redirect_to @portfolio, notice: "Withdraw #{withdraw_params[:amount]} #{@holding.coin.ticker}"
    end
  end

  private

  def withdraw_params
    params.require(:withdraw).permit(:coin_id, :portfolio_id, :amount)
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def set_coins
    @coins = @portfolio.holdings.map { |h| h.coin }
  end

  def witdhraw_error_redirect(message)
    set_coins
    flash.now[:alert] = message
    render :new, status: :unprocessable_entity
  end
end
