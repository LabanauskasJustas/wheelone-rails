class AddFieldsToRims < ActiveRecord::Migration[8.0]
  def change
    add_column :rims, :brand, :string
    add_column :rims, :diameter, :integer
    add_column :rims, :width, :decimal, precision: 4, scale: 1
    add_column :rims, :finish, :string
  end
end
