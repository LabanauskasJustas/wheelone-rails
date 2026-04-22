class RecordDetailComponent < ViewComponent::Base
  attr_reader :title, :image, :badge, :identifier, :status, :raw_status,
              :stats, :edit_path, :delete_path, :delete_confirm, :loading, :retry_path,
              :full_photo

  def initialize(title:, image: nil, badge: nil, identifier: nil, status: nil, raw_status: nil,
                 stats: [], edit_path: nil, delete_path: nil, delete_confirm: nil,
                 loading: false, retry_path: nil, full_photo: false)
    @title        = title
    @image        = image
    @badge        = badge
    @identifier   = identifier
    @status       = status
    @raw_status   = raw_status
    @stats        = stats
    @edit_path    = edit_path
    @delete_path  = delete_path
    @delete_confirm = delete_confirm
    @loading      = loading
    @retry_path   = retry_path
    @full_photo   = full_photo
  end

  def status_icon
    case raw_status
    when "ready"     then "check_circle"
    when "processing" then "autorenew"
    when "pending"   then "hourglass_empty"
    when "failed"    then "error"
    else "info"
    end
  end

  def status_color
    case raw_status
    when "ready"      then "text-[#1a8e1a]"
    when "processing" then "text-primary"
    when "pending"    then "text-on-surface-variant"
    when "failed"     then "text-[#be0614]"
    else "text-on-surface-variant"
    end
  end
end
