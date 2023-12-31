class HoldingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio, only: [:new, :create, :update, :destroy]
  before_action :set_coin, only: [:create]
  before_action :set_coins, only: [:new]
  before_action :set_holding, only: [:update]
  before_action :set_request_service, only: [:create, :update]

  def new
    @holding = Holding.new
  end

  def create
    @holding = @portfolio.holdings.build(holding_params)
    @coin.set_rate(@request_service)

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
    rescue ArgumentError, StandardError => e
      set_portfolio
      set_coins
      flash.now[:error] = e.message
      render "portfolios/show", status: :unprocessable_entity
    end
  end

  def destroy
    holding = Holding.find(params[:id])
    if holding.destroy!
      redirect_to @portfolio, notice: "#{holding.ticker} removed from portfolio"
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
    @coins = Coin.where(enabled: true).order(:ticker)
  end

  def set_holding
    @holding = Holding.find_by(
      portfolio_id: operation_params[:portfolio_id],
      coin_id: operation_params[:coin_id]
    )
  end

  def set_request_service
    conn = ApiConnectionService.build
    @request_service = ApiRequestsService.new(conn)
  end
end
