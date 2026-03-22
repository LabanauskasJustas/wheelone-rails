class Car < ApplicationRecord
  # Associations
  belongs_to :team
  has_many :visualizations, dependent: :destroy
  has_one_attached :photo
  attr_accessor :photo_removal
  after_save { photo.purge_later if photo_removal == "1" }

  # Normalizations
  normalizes :brand, with: ->(v) { v.strip }
  normalizes :model, with: ->(v) { v.strip }

  # Validations
  validates :brand, presence: true, length: { maximum: 100 }
  validates :model, presence: true, length: { maximum: 100 }
  validates :year, numericality: { only_integer: true, greater_than: 1885, less_than_or_equal_to: -> { Time.current.year + 1 } }, allow_nil: true

  # Scopes
  scope :search_by_name, ->(q) { where("brand ILIKE :q OR model ILIKE :q", q: "%#{sanitize_sql_like(q)}%") }
  scope :recent, -> { order(created_at: :desc) }

  # Public methods
  def display_name
    parts = [brand, model, year].compact.map(&:to_s).reject(&:empty?)
    parts.join(" ").presence || "Automobilis ##{id}"
  end
end
