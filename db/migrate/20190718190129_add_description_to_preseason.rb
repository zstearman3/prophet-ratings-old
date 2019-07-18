class AddDescriptionToPreseason < ActiveRecord::Migration[5.1]
  def change
    add_column :player_seasons, :preseason_description, :string
  end
end
