require 'rails_helper'

RSpec.describe "MlModels", type: :request do
  # describe "GET /api/v1/ml_models" do
  #   it "works! (now write some real specs)" do
  #     get api_v1_ml_models_path
  #     expect(response).to have_http_status(200)
  #   end
  # end
  let(:valid_attributes) {
    {
      name: 'categorizing news text',
    }
  }

  let(:invalid_attributes) {
    {
      name: nil,
    }
  }

  let(:valid_headers) {
    login(current_user)
    get_auth_params_from_login_response_headers(response)
  }
  # let(:current_user) { FactoryBot.create(:user, :with_3_sp_point) }

  describe "GET #index" do
    let(:current_user) { FactoryBot.create(:user) }
    it "returns a success response" do
      ml_model = current_user.ml_models.create! valid_attributes
      get '/api/v1/ml_models', params: {}, headers: valid_headers
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    let(:current_user) { FactoryBot.create(:user) }
    it "returns a success response" do
      ml_model = current_user.ml_models.create! valid_attributes
      get "/api/v1/ml_models/#{ml_model.id}", headers: valid_headers
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    let(:current_user) { FactoryBot.create(:user) }
    context "with valid params" do
      it "creates a new MlModel" do
        expect {
          post '/api/v1/ml_models', params: {ml_model: valid_attributes}, headers: valid_headers
        }.to change(MlModel, :count).by(1)
      end

      it "renders a JSON response with the new ml_model" do

        post '/api/v1/ml_models', params: {ml_model: valid_attributes}, headers: valid_headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new ml_model" do

        post '/api/v1/ml_models', params: {ml_model: invalid_attributes}, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    let(:current_user) { FactoryBot.create(:user) }
    context "with valid params" do
      let(:new_attributes) {
        {
          name: 'categorizing News',
        }
      }

      it "updates the requested ml_model" do
        ml_model = current_user.ml_models.create! valid_attributes
        put "/api/v1/ml_models/#{ml_model.id}", params: {ml_model: new_attributes}, headers: valid_headers
        ml_model.reload
        res = JSON(response.body)
        expect(res["name"]).to eq('categorizing News')
      end

      it "renders a JSON response with the ml_model" do
        ml_model = current_user.ml_models.create! valid_attributes

        put "/api/v1/ml_models/#{ml_model.id}", params: {ml_model: valid_attributes}, headers: valid_headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the ml_model" do
        ml_model = current_user.ml_models.create! valid_attributes

        put "/api/v1/ml_models/#{ml_model.id}", params: {id: ml_model.to_param, ml_model: invalid_attributes}, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    let(:current_user) { FactoryBot.create(:user) }
    it "destroys the requested ml_model" do
      ml_model = current_user.ml_models.create! valid_attributes
      expect {
        delete "/api/v1/ml_models/#{ml_model.id}", params: {id: ml_model.to_param}, headers: valid_headers
      }.to change(MlModel, :count).by(-1)
    end
  end
end
