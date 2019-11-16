class Api::V1::MlModels::UploadCsvController < ApplicationController
  before_action :authenticate_user!
  def create
    ml_model = current_user.ml_models.find(params[:ml_model_id])
    csv = params[:csv_file]
    header_row = CSV.open(csv, 'r') { |c| c.first }
    if header_row.size > 100
      render json: {message: 'We do not support more than 100 parameters'}, status: :unprocessable_entity
    elsif !header_row.include?("y")
      render json: {message: "Please make sure your CSV has 'y'"}, status: :unprocessable_entity
    elsif header_row.size != header_row.uniq.size
      render json: {message: 'Parameter headers must be unique'}, status: :unprocessable_entity
    elsif header_row.any? {|h| h.blank?}
      render json: {message: 'Each header must have value'}, status: :unprocessable_entity
    else
      # TODO: use active storage
      # if upload_to_s3(csv)
      #   DataExtractorFromCsvJob.perform_later(ml_model_id: ml_model.id)
      #   render json: {message: 'successfully uploaded CSV'}
      # else
      #   render json: {message: 'Something went wrong. try later'}, status: :unprocessable_entity and return
      # end
      DataExtractorFromCsvJob.perform_later(ml_model_id: ml_model.id)
      render json: {message: 'successfully uploaded CSV'}, status: 201
    end
  end
end
