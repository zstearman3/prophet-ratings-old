require 'net/http'

namespace :calcs do
  task game_stats: :environment do
    current_season = Season.find_by(season: 2019)
    games = Game.where(season: current_season)
    games.each do |game|
      if game.status == "Final" || game.status == "F/OT"
        game.is_completed = true
        home_team_game = game.team_games.find_by(home_or_away: "HOME")
        away_team_game = game.team_games.find_by(home_or_away: "AWAY")
        if home_team_game && away_team_game
          begin
            game.possessions = 0.5 * ((home_team_game.field_goals_attempted + (0.4 * home_team_game.free_throws_attempted) - (1.07 * (home_team_game.offensive_rebounds / (home_team_game.offensive_rebounds + away_team_game.defensive_rebounds))) *
            (home_team_game.field_goals_attempted - home_team_game.field_goals_made) + home_team_game.turnovers) + (away_team_game.field_goals_attempted + (0.4 * away_team_game.free_throws_attempted) -
            (1.07 * (away_team_game.offensive_rebounds/(away_team_game.offensive_rebounds + home_team_game.defensive_rebounds)) * (away_team_game.field_goals_attempted - away_team_game.field_goals_made) + away_team_game.turnovers)))
            game.home_offensive_efficiency = ((100 * game.home_team_score) / game.possessions).round(1)
            game.away_offensive_efficiency = ((100 * game.away_team_score) / game.possessions).round(1)
            game.pace = (40 * game.possessions / ((home_team_game.minutes + away_team_game.minutes) / 10)).round(1)
            game.save
          rescue
          
          end
        end
      end
    end
  end
end