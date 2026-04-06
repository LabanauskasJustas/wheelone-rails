class ApplicationController < ActionController::Base
  include Controllers::Base
  include Pagy::Backend

  protect_from_forgery with: :exception, prepend: true
end
