class CreateVisualizations < ActiveRecord::Migration[8.0]
  def change
    create_table :visualizations do |t|
      t.references :team, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.references :rim, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
