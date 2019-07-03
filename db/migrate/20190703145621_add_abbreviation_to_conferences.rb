class AddAbbreviationToConferences < ActiveRecord::Migration[5.1]
  def change
    add_column :conferences, :abbreviation, :string
    add_column :team_seasons, :initial_adj_o, :decimal
    add_column :team_seasons, :initial_adj_d, :decimal
    add_column :team_seasons, :initial_adj_t, :decimal
  end
end
