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
      season_turnovers = 0
      season_turnovers_allowed = 0
      season_possessions = 0
      season_possessions_allowed = 0
      season_offensive_rebounds = 0
      season_defensive_rebounds = 0
      season_offensive_rebounds_allowed = 0
      season_defensive_rebounds_allowed = 0
      season_free_throws_attempted = 0
      season_field_goals_attempted = 0
      season_free_throws_attempted_allowed = 0
      season_blocked_shots = 0
      season_two_pointers_attempted = 0
      season_blocked_shots_allowed = 0
      season_two_pointers_attempted_allowed = 0
      season_steals = 0
      season_steals_allowed = 0
      season_three_pointers_attempted = 0
      season_three_pointers_attempted_allowed = 0
      season_assists = 0
      season_assists_allowed = 0
      season_field_goals = 0
      team_games = TeamGame.where(season: current_season, team: season.team)
      team_games.each do |game|
        if game.game.is_completed && game.game.possessions
          opponent_game = game.game.team_games.find_by(team: game.opponent)
          season_efficiency_total += (100 * game.points.to_f / game.game.possessions)
          season_turnovers += game.turnovers
          season_possessions += game.game.possessions
          season_games_total += 1
          season_free_throws_attempted += game.free_throws_attempted
          season_field_goals_attempted += game.field_goals_attempted
          season_three_pointers_attempted += game.three_pointers_attempted
          season_field_goals += game.field_goals_made
          season_assists += game.assists
          if opponent_game
            season_efficiency_allowed += (100 * opponent_game.points.to_f / game.game.possessions)
            season_field_goals_allowed += opponent_game.field_goals_made
            season_three_pointers_allowed += opponent_game.three_pointers_made
            season_field_goals_attempted_allowed += opponent_game.field_goals_attempted
            season_turnovers_allowed += opponent_game.turnovers
            season_possessions_allowed += game.game.possessions
            season_games_allowed += 1
            season_offensive_rebounds += game.offensive_rebounds
            season_defensive_rebounds += game.defensive_rebounds
            season_offensive_rebounds_allowed += opponent_game.offensive_rebounds
            season_defensive_rebounds_allowed += opponent_game.defensive_rebounds
            season_free_throws_attempted_allowed += opponent_game.free_throws_attempted
            season_blocked_shots += game.blocked_shots
            season_two_pointers_attempted_allowed += opponent_game.two_pointers_attempted
            season_blocked_shots_allowed += opponent_game.blocked_shots
            season_two_pointers_attempted += game.two_pointers_attempted
            season_steals += game.steals
            season_steals_allowed += opponent_game.steals
            season_three_pointers_attempted_allowed += opponent_game.three_pointers_attempted
            season_assists_allowed += opponent_game.assists
          end
        end
      end
      season.offensive_efficiency = (season_efficiency_total / season_games_total).round(1)
      season.defensive_efficiency = (season_efficiency_allowed / season_games_allowed).round(1)
      season.effective_field_goals_percentage_allowed = (100 * (season_field_goals_allowed + (0.5 * season_three_pointers_allowed)) / season_field_goals_attempted_allowed.to_f).round(1)
      season.turnovers_percentage = (100 * season_turnovers.to_f / season_possessions).round(1)
      season.turnovers_percentage_allowed = (100 * season_turnovers_allowed.to_f / season_possessions_allowed).round(1)
      season.offensive_rebounds_percentage = (100 * season_offensive_rebounds.to_f / (season_offensive_rebounds + season_defensive_rebounds_allowed)).round(1)
      season.defensive_rebounds_percentage = (100 * season_defensive_rebounds.to_f / (season_defensive_rebounds + season_offensive_rebounds_allowed)).round(1)
      season.free_throws_rate = (100 * season_free_throws_attempted.to_f / season_field_goals_attempted).round(1)
      season.free_throws_rate_allowed = (100 * season_free_throws_attempted_allowed / season_field_goals_attempted_allowed).round(1)
      season.blocks_percentage = (100 * season_blocked_shots.to_f / season_two_pointers_attempted_allowed).round(1)
      season.blocks_percentage_allowed = (100 * season_blocked_shots_allowed.to_f / season_two_pointers_attempted).round(1)
      season.steals_percentage = (100 * season_steals.to_f / season_possessions_allowed).round(1)
      season.steals_percentage_allowed = (100 * season_steals_allowed.to_f / season_possessions_allowed).round(1)
      season.three_pointers_rate = (100 * season_three_pointers_attempted.to_f / season_field_goals_attempted).round(1)
      season.three_pointers_rate_allowed = (100 * season_three_pointers_attempted_allowed.to_f / season_field_goals_attempted_allowed).round(1)
      season.assists_percentage = (100 * season_assists.to_f / season_field_goals).round(1)
      season.assists_percentage_allowed = (100 * season_assists_allowed.to_f / season_field_goals_allowed).round(1)
      season.save
    end
  end
end