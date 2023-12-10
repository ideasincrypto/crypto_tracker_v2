class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:new, :create, :index]
  before_action :set_portfolio, only: [:show, :index]
  before_action :set_request_service, only: [:show]

  def new
    @portfolio = Portfolio.new
  end

  def create
    @portfolio = @account.portfolios.build(portfolio_params)

    if @portfolio.save
      redirect_to @portfolio, notice: "Portfolio created successfuly"
    else
      flash.now[:error] = "ERROR: couldn't save portfolio"
      render :new, status: :unprocessable_entity
    end
  end

  def index; end

  def show
    @coins = @portfolio.holdings.map { |h| h.coin }
    @portfolio.refresh_rates(@request_service)
    @portfolio.holdings.reload
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

  def set_request_service
    conn = ApiConnectionService.build
    @request_service = ApiRequestsService.new(conn)
  end
end
