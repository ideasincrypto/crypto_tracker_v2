class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @portfolios = current_user.account.portfolios.all
  end
end
