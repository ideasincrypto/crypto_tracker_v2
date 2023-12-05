class HomeController < ApplicationController
  def index
    @portfolio = Holding.all
  end
end
