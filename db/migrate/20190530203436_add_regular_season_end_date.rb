class AddRegularSeasonEndDate < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :active, :boolean
    add_column :seasons, :post_season_end_date, :date
  end
end
