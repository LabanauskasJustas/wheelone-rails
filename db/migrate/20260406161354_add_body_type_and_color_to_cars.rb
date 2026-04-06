class AddBodyTypeAndColorToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :body_type, :string
    add_column :cars, :color, :string
  end
end
