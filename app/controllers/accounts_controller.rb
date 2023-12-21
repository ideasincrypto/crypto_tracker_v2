class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show assets ]

  def show; end

  def assets
    @assets = @account.assets
  end

  private

  def set_account
    @account = current_user.account
  end
end
