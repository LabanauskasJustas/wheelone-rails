class PhotoHintComponent < ViewComponent::Base
  attr_reader :title, :paragraphs, :tiles, :subdir

  def initialize(title:, paragraphs:, tiles:, subdir: "cars")
    @title      = title
    @paragraphs = paragraphs
    @tiles      = tiles
    @subdir     = subdir
  end

  def status_icon(status)
    status == :good ? "check" : "close"
  end

  def status_color(status)
    status == :good ? "bg-[#1a8e1a]" : "bg-[#be0614]"
  end
end
