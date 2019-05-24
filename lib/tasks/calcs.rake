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
  
  task season_stats: :environment do
    current_season = Season.find_by(season: 2019)
    team_seasons = TeamSeason.where(season: current_season)
    team_seasons.each do |season|
      season_efficiency_total = 0
      season_games_total = 0
      season_efficiency_allowed = 0
      season_games_allowed = 0
      season_field_goals_allowed = 0
      season_field_goals_attempted_allowed = 0
      season_three_pointers_allowed = 0
      team_games = TeamGame.where(season: current_season, team: season.team)
      team_games.each do |game|
        if game.game.is_completed && game.game.possessions
          opponent_game = game.game.team_games.find_by(team: game.opponent)
          season_efficiency_total += (100 * game.points.to_f / game.game.possessions)
          season_games_total += 1
          if opponent_game
            season_efficiency_allowed += (100 * opponent_game.points.to_f / game.game.possessions)
            season_field_goals_allowed += opponent_game.field_goals_made
            season_three_pointers_allowed += opponent_game.three_pointers_made
            season_field_goals_attempted_allowed += opponent_game.field_goals_attempted
            season_games_allowed += 1
          end
        end
      end
      season.offensive_efficiency = (season_efficiency_total / season_games_total).round(1)
      season.defensive_efficiency = (season_efficiency_allowed / season_games_allowed).round(1)
      season.effective_field_goals_percentage_allowed = (100 * (season_field_goals_allowed + (0.5 * season_three_pointers_allowed)) / season_field_goals_attempted_allowed.to_f).round(1)
      season.save
    end
  end
end