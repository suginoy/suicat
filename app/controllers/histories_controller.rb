class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @histories = current_user.histories
  end
end
