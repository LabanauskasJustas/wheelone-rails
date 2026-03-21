json.extract! car,
  :id,
  :team_id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at

json.photo url_for(car.photo) if car.photo.attached?
# 🚅 super scaffolding will insert file-related logic above this line.
