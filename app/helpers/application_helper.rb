module ApplicationHelper
  include Helpers::Base
  include Pagy::Frontend

  def current_theme
    :light
  end
end
