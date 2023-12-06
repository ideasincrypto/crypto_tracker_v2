class HomeController < ApplicationController
  def index
    @portfolios = current_user.account.portfolios.all
  end
end
