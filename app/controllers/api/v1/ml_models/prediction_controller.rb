class Api::V1::MlModels::PredictionController < ApplicationController
  before_action :authenticate_user!

  # POST because this sometimes needs to handle long text.
  def create
    ml_model = current_user.ml_models.find(params[:ml_model_id])
    if ml_model.ready?
      parameter_names = ml_model.train_data.first.try(:train_parameters).try(:pluck, :name) || []
      parameter_keys = params[:target_parameters].map{|t| t.keys.first }.compact
      if parameter_keys.sort == parameter_names.sort

        # TODO: return actual value
        render json: {predicted: 'entertainment'}, status: 200
      else
        render json: {message: 'invalid parameters'}, status: 422
      end
    else
      render json: {message: 'this model has not been trained'}, status: 422
    end
  end

  private

  # def prediction_params
  #   params.fetch(:target_parameters, [])
  # end
end
