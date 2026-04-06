class Car < ApplicationRecord
  # Associations
  belongs_to :team
  has_many :visualizations, dependent: :destroy
  has_one_attached :photo
  attr_accessor :photo_removal
  after_save { photo.purge_later if photo_removal == "1" }

  # Enums
  BODY_TYPES = %w[sedan coupe suv hatchback wagon convertible].freeze
  enum :body_type, BODY_TYPES.index_by(&:itself), prefix: false, validate: { allow_nil: true }

  # Normalizations
  normalizes :brand, with: ->(v) { v.strip }
  normalizes :model, with: ->(v) { v.strip }
  normalizes :color, with: ->(v) { v.strip.truncate(60) }

  # Validations
  validates :brand, presence: true, length: { maximum: 100 }
  validates :model, presence: true, length: { maximum: 100 }
  validates :year, numericality: { only_integer: true, greater_than: 1885, less_than_or_equal_to: -> { Time.current.year + 1 } }, allow_nil: true

  # Scopes
  scope :search_by_name, ->(q) { where("brand ILIKE :q OR model ILIKE :q", q: "%#{sanitize_sql_like(q)}%") }
  scope :recent, -> { order(created_at: :desc) }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[brand model year body_type color created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Public methods
  def display_name
    parts = [brand, model, year].compact.map(&:to_s).reject(&:empty?)
    parts.join(" ").presence || "Automobilis ##{id}"
  end
end
