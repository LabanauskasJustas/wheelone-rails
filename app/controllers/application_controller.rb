class ApplicationController < ActionController::Base
  include Controllers::Base
  include Pagy::Backend

  protect_from_forgery with: :exception, prepend: true

  private

  def set_locale(&action)
    locale = [
      current_user&.locale,
      current_user&.current_team&.locale,
      I18n.default_locale.to_s
    ].compact.find { |l| I18n.available_locales.include?(l.to_sym) }
    I18n.with_locale(locale, &action)
  end
end
