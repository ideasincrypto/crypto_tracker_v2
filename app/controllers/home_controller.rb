class HomeController < ApplicationController
  # before_action :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      @portfolios = current_user.account.portfolios.all
    else
      redirect_to visitors_path unless current_user
    end
  end

  def visitors; end
end
