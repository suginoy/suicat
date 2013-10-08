require 'spec_helper'

describe Api::Users::HistoriesController do
  def api_history_params
    {user_id: 1, key: 'key', idm: 'idm', raw_data: 'raw'}
  end

  describe "#create" do
    before do
      user = build(:user, key: "key")
      User.stub_chain(:where, :first).and_return(user)
      post :create, api_history_params.merge(format: :json)
    end
    its(:response) { should be_success }
  end
end
