require 'spec_helper'

describe Api::Users::HistoriesController do
  describe "#create" do
    context "valid params" do
      before do
        Api::History.any_instance.stub(save: true)
        post :create, user_id: "1", format: :json
      end
      its(:response) { should be_success }
    end

    context "invalid params" do
      before do
        Api::History.any_instance.stub(save: false)
        post :create, user_id: "1", format: :json
      end
      its(:response) { should be_unprocessable }
    end
  end
end
