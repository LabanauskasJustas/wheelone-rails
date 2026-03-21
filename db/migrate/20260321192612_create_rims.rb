class CreateRims < ActiveRecord::Migration[8.0]
  def change
    create_table :rims do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
