# frozen_string_literal: true

class Visualization::Processor
  REDIS_QUEUE = "wheelone_vision"

  def self.call(visualization)
    new(visualization).call
  end

  def initialize(visualization)
    @visualization = visualization
  end

  def call
    payload = build_payload
    redis = Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
    redis.call("RPUSH", REDIS_QUEUE, payload.to_json)
    Rails.logger.info("[Processor] enqueued visualization=#{@visualization.id}")
  rescue => e
    Rails.logger.error("[Processor] Redis failure visualization=#{@visualization.id} error=#{e.message}")
    raise
  ensure
    redis&.close
  end

  private

  attr_reader :visualization

  def build_payload
    car = @visualization.car
    rim = @visualization.rim
    host = ENV.fetch("RAILS_INTERNAL_HOST", "http://localhost:3000")

    payload = {
      visualization_id: @visualization.id,
      callback_url: "#{host}/api/v1/visualizations/#{@visualization.id}/callback",
      car: car_payload(car, host),
      rim: rim_payload(rim, host)
    }

    payload
  end

  def car_payload(car, host)
    data = {
      id: car.id,
      brand: car.brand,
      model: car.model,
      image_url: blob_url(car.photo, host)
    }
    data[:year] = car.year if car.year.present?
    data[:body_type] = car.body_type if car.body_type.present?
    data[:color] = car.color if car.color.present?
    data
  end

  def rim_payload(rim, host)
    data = {
      id: rim.id,
      name: rim.name,
      image_url: blob_url(rim.photo, host)
    }
    data[:brand] = rim.brand if rim.brand.present?
    data[:diameter] = rim.diameter if rim.diameter.present?
    data[:width] = rim.width if rim.width.present?
    data[:finish] = rim.finish if rim.finish.present?
    data
  end

  def blob_url(attachment, host)
    variant = attachment.variant(format: :jpeg).processed
    Rails.application.routes.url_helpers.rails_representation_url(variant, host: host)
  end
end
