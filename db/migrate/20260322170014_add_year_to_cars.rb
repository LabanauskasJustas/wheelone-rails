class AddYearToCars < ActiveRecord::Migration[8.0]
  def change
    add_column :cars, :year, :integer
  end
end
