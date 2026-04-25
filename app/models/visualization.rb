class Visualization < ApplicationRecord
  include CableReady::Updatable
  enable_cable_ready_updates on: :update

  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :car
  belongs_to :rim
  has_one_attached :result_image
  attr_accessor :result_image_removal
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  enum :status, {
    pending: "pending",
    processing: "processing",
    ready: "ready",
    failed: "failed"
  }, default: "pending"

  scope :recent, -> { order(created_at: :desc) }
  scope :completed, -> { where(status: :ready) }
  # 🚅 add scopes above.

  validates :car, presence: true
  validates :rim, presence: true
  # 🚅 add validations above.

  after_create_commit :enqueue_processing
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[status car_id rim_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[car rim]
  end

  def valid_cars
    team.cars.with_attached_photo
  end

  def valid_rims
    team.rims.with_attached_photo
  end

  def display_name
    "#{car.display_name} + #{rim.name}"
  end

  def label_string
    display_name
  end

  def append_step(name, status, detail = {})
    steps = (processing_steps || []).dup
    existing_idx = steps.index { |s| s["name"] == name.to_s }

    step_data = {
      "name"   => name.to_s,
      "status" => status.to_s,
      "detail" => (detail || {}),
      "at"     => Time.current.iso8601,
    }

    if existing_idx
      steps[existing_idx] = step_data
    else
      steps << step_data
    end

    update_columns(processing_steps: steps)
    _broadcast_step(step_data, existing_idx ? :replace : :append)
  end

  # 🚅 add methods above.

  private

  def _broadcast_step(step_data, action)
    html = ApplicationController.render(
      partial: "account/visualizations/processing_step",
      locals: { step: step_data },
    )
    if action == :append
      Turbo::StreamsChannel.broadcast_append_to(
        "visualization_#{id}_steps",
        target: "visualization-steps",
        html: html,
      )
    else
      Turbo::StreamsChannel.broadcast_replace_to(
        "visualization_#{id}_steps",
        target: "visualization-step-#{step_data["name"]}",
        html: html,
      )
    end
  end

  def enqueue_processing
    VisualizationProcessingJob.perform_later(id)
  end
end
