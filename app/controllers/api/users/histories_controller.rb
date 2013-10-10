class Api::Users::HistoriesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def create
    @api_history = Api::History.new(api_history_params)

    if @api_history.save
      render json: @api_history.to_json, status: :created
    else
      render json: @api_history.errors, status: :unprocessable_entity
    end
  end

  private
  def api_history_params
    params.permit(:user_id, :key, :idm, :raw_data)
  end
end
