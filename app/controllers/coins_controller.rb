class CoinsController < ApplicationController
  def index
    @coins = Coin.all.where(enabled: true)
  end
end
