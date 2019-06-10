class AddAdvancedPlayerSeasonStats < ActiveRecord::Migration[5.1]
  def change
    add_column :player_seasons, :bpm, :decimal
    add_column :player_seasons, :offensive_bpm, :decimal
    add_column :player_seasons, :defensive_bpm, :decimal
    add_column :player_seasons, :aper, :decimal
    add_column :player_seasons, :prophet_rating, :decimal
    add_column :seasons, :aper, :decimal
  end
end
