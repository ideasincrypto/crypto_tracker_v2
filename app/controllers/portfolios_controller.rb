class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:new, :create, :index]
  before_action :set_portfolio, only: [:show, :index]

  def new
    @portfolio = Portfolio.new
  end

  def create
    @portfolio = @account.portfolios.build(portfolio_params)

    if @portfolio.save
      redirect_to @portfolio, notice: "Portfolio created successfuly"
    else
      flash.now[:alert] = "ERROR: couldn't save portfolio"
      render :new
    end
  end

  def index; end

  def show
    @coins = @portfolio.holdings.map { |h| h.coin }
  end

  def refresh
    # instantiate connection object
    # instantiate api request object
    # make a request for all coins in portfolio
    # update all holdings' rate attribute
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def set_account
    @account = current_user.account
  end

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end
end
