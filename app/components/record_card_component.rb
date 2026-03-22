class RecordCardComponent < ViewComponent::Base
  attr_reader :record, :show_path, :edit_path, :image, :title, :subtitle, :badge, :badge_color

  # badge_color: one of "gray" | "yellow" | "blue" | "green" | "red"
  def initialize(record:, show_path:, edit_path: nil, image: nil, title:, subtitle: nil, badge: nil, badge_color: "gray")
    @record = record
    @show_path = show_path
    @edit_path = edit_path
    @image = image
    @title = title
    @subtitle = subtitle
    @badge = badge
    @badge_color = badge_color
  end

  def badge_classes
    base = "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium"
    color_map = {
      "gray"   => "bg-base-200 text-base-600 dark:bg-base-700 dark:text-base-300",
      "yellow" => "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200",
      "blue"   => "bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200",
      "green"  => "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200",
      "red"    => "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
    }
    "#{base} #{color_map.fetch(badge_color, color_map["gray"])}"
  end
end
