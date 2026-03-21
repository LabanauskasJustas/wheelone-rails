json.extract! rim,
  :id,
  :team_id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at

json.photo url_for(rim.photo) if rim.photo.attached?
# 🚅 super scaffolding will insert file-related logic above this line.
