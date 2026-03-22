class RecordDetailComponent < ViewComponent::Base
  attr_reader :title, :image, :badge, :identifier, :status, :stats, :edit_path, :delete_path, :delete_confirm

  # stats: array of { label: String, value: String } hashes
  def initialize(title:, image: nil, badge: nil, identifier: nil, status: nil,
                 stats: [], edit_path: nil, delete_path: nil, delete_confirm: nil)
    @title        = title
    @image        = image
    @badge        = badge
    @identifier   = identifier
    @status       = status
    @stats        = stats
    @edit_path    = edit_path
    @delete_path  = delete_path
    @delete_confirm = delete_confirm
  end
end
