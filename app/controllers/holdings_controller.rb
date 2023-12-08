class HoldingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio, only: [:new, :create, :update]
  before_action :set_coin, only: [:create]
  before_action :set_coins, only: [:new]
  before_action :set_holding, only: [:update]

  def new
    @holding = Holding.new
  end

  def create
    @holding = @portfolio.holdings.build(holding_params)
    if @holding.save
      redirect_to @portfolio, notice: "#{@coin.ticker} added to Portfolio"
    else
      set_coins
      flash.now[:alert] = "ERROR: couldn't save coin"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    begin

      case operation_params[:operation]
      when "deposit"
        @holding.deposit(operation_params[:amount].to_d)
        redirect_to @portfolio, notice: "Successfully deposited #{operation_params[:amount].to_d} #{@holding.ticker}"
      when "withdraw"
        @holding.withdraw(operation_params[:amount].to_d)
        redirect_to @portfolio, notice: "Successfully withdrew #{operation_params[:amount].to_d} #{@holding.ticker}"
      when "update"
        @holding.update_value(operation_params[:amount].to_d)
        redirect_to @portfolio, notice: "Updated #{@holding.ticker} value to #{operation_params[:amount].to_d}"
      end

    rescue ArgumentError => e
      set_portfolio
      set_coins
      flash.now[:error] = e.message
      render "portfolios/show", status: :unprocessable_entity
    end
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def holding_params
    params.require(:holding).permit(:coin_id, :amount)
  end

  def operation_params
    params.permit(:operation, :coin_id, :amount, :portfolio_id)
  end

  def set_coin
    @coin = Coin.find(params.dig(:holding, :coin_id))
  end

  def set_coins
    @coins = Coin.where(enabled: true)
  end

  def set_holding
    @holding = Holding.find_by(
      portfolio_id: operation_params[:portfolio_id],
      coin_id: operation_params[:coin_id]
    )
  end
end
