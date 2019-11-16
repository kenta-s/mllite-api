class DataExtractorFromCsvJob < ApplicationJob
  queue_as :csv

  def perform(csv:)
  end
end
