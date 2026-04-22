# frozen_string_literal: true

class VisualizationFetchImageJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 5

  sidekiq_retries_exhausted do |job, ex|
    visualization = Visualization.find_by(id: job["args"].first)
    visualization&.failed!
  end

  def perform(visualization_id)
    visualization = Visualization.find(visualization_id)
    return unless visualization.processing?

    python_host = ENV.fetch("PYTHON_HOST", "http://localhost:8001")
    uri = URI.parse("#{python_host}/api/v1/results/#{visualization_id}/image")

    response = Net::HTTP.start(uri.host, uri.port, read_timeout: 30, open_timeout: 5) do |http|
      http.get(uri.request_uri)
    end

    raise "Python returned #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    visualization.result_image.attach(
      io: StringIO.new(response.body),
      filename: "visualization_#{visualization_id}.jpg",
      content_type: "image/jpeg"
    )
    visualization.ready!
  end
end
