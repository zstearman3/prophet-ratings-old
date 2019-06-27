class AddDescriptionToPredictions < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :description, :text
  end
end
