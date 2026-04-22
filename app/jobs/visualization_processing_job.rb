class VisualizationProcessingJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 5

  def perform(visualization_id)
    visualization = Visualization.find(visualization_id)
    return unless visualization.pending?

    visualization.processing!
    Visualization::Processor.call(visualization)
  rescue => e
    visualization&.failed!
    raise e
  end
end
