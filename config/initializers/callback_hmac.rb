if Rails.env.production? && ENV["CALLBACK_HMAC_SECRET"].blank?
  raise "CALLBACK_HMAC_SECRET must be set in production"
end
