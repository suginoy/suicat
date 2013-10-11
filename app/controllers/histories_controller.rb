class HistoriesController < ApplicationController
  before_action :authenticate_user!

  HISTORY_PER = 20

  def index
    @histories = current_user.histories.page(params[:page]).per(HISTORY_PER)
  end
end
