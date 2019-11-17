require 'rails_helper'
require 'csv'

RSpec.describe "UploadCsv", type: :request do
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

  #  [
  #    ['news content', 'media name', 'y'],
  #    ['a famous celebrity passed away', 'TIME', 'entertainment'],
  #    ['Johnny Depp got married', 'Haff Post', 'entertainment'],
  #    ['succeeded to build a time machine', 'Scientific American', 'science'],
  #    ['NFL should discipline QB Rudolph for role in fight', 'usatoday.com', 'sports'],
  #    ['Why Garret likely will not face charges after attack', 'usatoday.com', 'sports'],
  #  ]
  let(:valid_csv) {
    fixture_file_upload(Rails.root.join('spec', 'fixtures', 'valid.csv'), 'text/csv')
  }

  describe "POST #create" do
    let(:current_user) { FactoryBot.create(:user) }
    let!(:ml_model) { FactoryBot.create(:ml_model, user: current_user) }
    context "with valid params" do
      it "enqueues something" do
        post "/api/v1/ml_models/#{ml_model.id}/upload_csv", params: {csv_file: valid_csv}, headers: valid_headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(ml_model.train_parameters.pluck(:name)).to contain_exactly('news content', 'media name')
      end
    end

    context "with invalid params" do
      let(:csv_without_y) {
        fixture_file_upload(Rails.root.join('spec', 'fixtures', 'without_y.csv'), 'text/csv')
      }

      it "renders a JSON response with errors for the new ml_model" do
        post "/api/v1/ml_models/#{ml_model.id}/upload_csv", params: {csv_file: csv_without_y}, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
