class Api::V1::MlModelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ml_model, only: [:show, :update, :destroy]

  # GET /api/v1/ml_models
  def index
    @ml_models = current_user.ml_models

    render json: @ml_models
  end

  # GET /api/v1/ml_models/1
  def show
    parameter_names = @ml_model.train_data.first.try(:train_parameters).try(:pluck, :name) || []
    render json: {
      id: @ml_model.id,
      name: @ml_model.name,
      status: @ml_model.status,
      parameterNames: parameter_names
    }
  end

  # POST /api/v1/ml_models
  def create
    @ml_model = current_user.ml_models.new(ml_model_params)

    if @ml_model.save
      render json: @ml_model, status: :created
    else
      render json: @ml_model.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/ml_models/1
  def update
    if @ml_model.update(ml_model_params)
      render json: @ml_model
    else
      render json: @ml_model.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/ml_models/1
  def destroy
    @ml_model.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ml_model
      @ml_model = current_user.ml_models.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ml_model_params
      params.fetch(:ml_model, {}).permit(:name)
    end
end
