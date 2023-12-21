class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[ new create index ]
  before_action :set_portfolio, only: %i[ show ]
  before_action :set_holdings, only: %i[ show ]
  before_action :set_request_service, only: %i[ show ]

  def new
    @portfolio = Portfolio.new
  end

  def create
    @portfolio = @account.portfolios.build(portfolio_params)

    respond_to do |format|
      if @portfolio.save
        format.turbo_stream
        format.html { redirect_to @portfolio, notice: "Portfolio created successfuly" }
      else
        flash.now[:error] = "ERROR: couldn't save portfolio"
        render :new, status: :unprocessable_entity
      end
    end
  end

  def index
    @portfolios = current_user.portfolios
  end

  def show
    @portfolio.refresh_rates(@request_service)
    @portfolio.holdings.reload
    @coins = @portfolio.holdings.map { |h| h.coin }
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def set_account
    @account = current_user.account
  end

  def set_holdings
    @holdings = @portfolio.holdings.sort { |a, b| b.value <=> a.value }
  end

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end

  def set_request_service
    conn = ApiConnectionService.build
    @request_service = ApiRequestsService.new(conn)
  end
end
