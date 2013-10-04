require 'spec_helper'

describe Api::Users::HistoriesController do
  def api_history_params
    {user_id: 1, key: 'key', idm: 'idm', raw_data: 'raw'}
  end

  describe "#create" do
    before { post :create, api_history_params.merge(format: :json) }
    its(:response) { should be_success }
  end
end
