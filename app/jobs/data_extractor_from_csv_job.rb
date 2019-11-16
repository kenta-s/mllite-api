require 'csv'

class DataExtractorFromCsvJob < ApplicationJob
  queue_as :csv

  def perform(ml_model_id:)
    ml_model = MlModel.find(ml_model_id)

    # # TODO: make sure this works
    # CSV.foreach(ml_model.csv, headers: true) do |csv|
    #   p csv
    # end
  end
end
