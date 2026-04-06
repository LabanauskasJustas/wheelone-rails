class Visualization < ApplicationRecord
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

  # 🚅 add methods above.

  private

  def enqueue_processing
    VisualizationProcessingJob.perform_later(id)
  end
end
