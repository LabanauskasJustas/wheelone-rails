class AddBrandAndModelToCars < ActiveRecord::Migration[8.0]
  def up
    add_column :cars, :brand, :string
    add_column :cars, :model, :string

    # Migrate existing name data into brand
    execute "UPDATE cars SET brand = name, model = '' WHERE brand IS NULL"

    change_column_null :cars, :brand, false
    change_column_null :cars, :model, false

    remove_column :cars, :name
  end

  def down
    add_column :cars, :name, :string

    execute "UPDATE cars SET name = TRIM(brand || ' ' || model)"

    change_column_null :cars, :name, false
    remove_column :cars, :brand
    remove_column :cars, :model
  end
end
