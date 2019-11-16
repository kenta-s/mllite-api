require 'rails_helper'
require 'csv'

RSpec.describe "Prediction", type: :request do
  let(:valid_attributes) {
    {
      news_content: 'Johnny Depp got married',
      media_name: 'Haff Post',
    }
  }

  let(:invalid_attributes) {
    {
      news_content: 'Johnny Depp got married',
      media_name: 'Haff Post',
      not_allowed_parameter: 'this is not allowed',
    }
  }

  let(:valid_headers) {
    login(current_user)
    get_auth_params_from_login_response_headers(response)
  }

  describe "POST #create" do
    let(:current_user) { FactoryBot.create(:user) }
    let!(:ml_model) { FactoryBot.create(:ml_model, :ready, user: current_user) }

    context "with valid params" do
      it "renders a JSON response with predicted value" do
        post "/api/v1/ml_models/#{ml_model.id}/prediction", params: {target_parameters: valid_attributes}, headers: valid_headers
        expect(response).to have_http_status(:success)
        res = JSON(response.body)
        expect(res["predicted"]).to eq("entertainment")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        post "/api/v1/ml_models/#{ml_model.id}/prediction", params: {target_parameters: invalid_attributes}, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end

