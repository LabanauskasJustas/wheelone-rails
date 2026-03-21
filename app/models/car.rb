class Car < ApplicationRecord
  # Associations
  belongs_to :team
  has_one_attached :photo

  # Normalizations
  normalizes :name, with: ->(name) { name.strip }

  # Validations
  validates :name, presence: true, length: { maximum: 100 }

  # Scopes
  scope :search_by_name, ->(q) { where("name ILIKE ?", "%#{sanitize_sql_like(q)}%") }
  scope :recent, -> { order(created_at: :desc) }

  # Public methods
  def display_name
    name.presence || "Automobilis ##{id}"
  end
end
