class Rim < ApplicationRecord
  # Associations
  belongs_to :team
  has_many :visualizations, dependent: :destroy
  has_one_attached :photo
  attr_accessor :photo_removal

  # Normalizations
  normalizes :name,   with: ->(name) { name.strip }
  normalizes :brand,  with: ->(v) { v.strip.truncate(60) }
  normalizes :finish, with: ->(v) { v.strip.truncate(60) }

  # Validations
  validates :name,   presence: true, length: { maximum: 100 }
  validates :brand,  presence: true
  validates :finish, presence: true
  validate :photo_required_on_create
  validates :diameter, numericality: { only_integer: true, greater_than_or_equal_to: 14, less_than_or_equal_to: 40 }, allow_nil: true
  validates :width,    numericality: { greater_than_or_equal_to: 3.0, less_than_or_equal_to: 30.0 }, allow_nil: true

  # Scopes
  scope :search_by_name, ->(q) { where("name ILIKE ?", "%#{sanitize_sql_like(q)}%") }
  scope :recent, -> { order(created_at: :desc) }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[name brand diameter width finish created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Public methods
  def display_name
    name.presence || "Ratlankis ##{id}"
  end

  private

  def photo_required_on_create
    errors.add(:photo, :blank) if !photo.attached? || photo_removal == "1"
  end
end
