class AddProcessingStepsToVisualizations < ActiveRecord::Migration[8.0]
  def change
    add_column :visualizations, :processing_steps, :jsonb, null: false, default: []
  end
end
