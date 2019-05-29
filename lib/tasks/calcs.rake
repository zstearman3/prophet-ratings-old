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
      season_points_allowed = 0
      team_games = TeamGame.where(season: current_season, team: season.team)
      team_games.each do |game|
        if game.game.is_completed && game.game.possessions && game.minutes > 0
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
            season_points_allowed += opponent_game.points
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
      season.true_shooting_percentage_allowed = (100 * season_points_allowed / (2 * (season_field_goals_attempted_allowed + (0.44 * season_free_throws_attempted_allowed)))).round(1)
      season.save
    end
    team_seasons = TeamSeason.where(season: current_season)
    current_season.offensive_efficiency = team_seasons.average(:offensive_efficiency)
    current_season.defensive_efficiency = team_seasons.average(:defensive_efficiency)
    current_season.effective_field_goals_percentage = team_seasons.average(:effective_field_goals_percentage)
    current_season.turnovers_percentage = team_seasons.average(:turnovers_percentage)
    current_season.free_throws_rate = team_seasons.average(:free_throws_rate)
    current_season.offensive_rebounds_percentage = team_seasons.average(:offensive_rebounds_percentage)
    current_season.defensive_rebounds_percentage = team_seasons.average(:defensive_rebounds_percentage)
    current_season.blocks_percentage = team_seasons.average(:blocks_percentage)
    current_season.steals_percentage = team_seasons.average(:steals_percentage)
    current_season.three_pointers_rate = team_seasons.average(:three_pointers_rate)
    current_season.assists_percentage = team_seasons.average(:assists_percentage)
    current_season.true_shooting_percentage = team_seasons.average(:true_shooting_percentage)
    current_season.save
    team_seasons.each do |season|
      season.defensive_aggression = - ((3 * (season.assists_percentage_allowed - current_season.assists_percentage)) + (3 * (season.three_pointers_rate_allowed - current_season.three_pointers_rate)) -
                                     (2 * (season.free_throws_rate_allowed - current_season.free_throws_rate)) - (season.turnovers_percentage_allowed - current_season.turnovers_percentage) - (season.defensive_rebounds_percentage - current_season.defensive_rebounds_percentage)).round(1)
      if season.defensive_aggression < -40
        season.defensive_fingerprint = "Mostly Zone"
      elsif season.defensive_aggression < -20
        season.defensive_fingerprint = "Some Zone"
      elsif season.defensive_aggression < 20
       season.defensive_fingerprint = "Balanced"
      elsif season.defensive_aggression < 40
        season.defensive_fingerprint = "Mostly Man"
      else
        season.defensive_fingerprint = "Aggressive Man"
      end
      season.save
    end
  end
  
  task rating_calc: :environment do
    current_season = Season.find_by(season: 2019)
    team_seasons = TeamSeason.where(season: current_season)
    # team_seasons.each do |season|
    #   season.adj_offensive_efficiency = season.offensive_efficiency
    #   season.adj_defensive_efficiency = season.defensive_efficiency
    #   season_tempo = 0
    #   team_games = TeamGame.where(team: season.team, season: current_season).order(day: :asc)
    #   game_count = 0
    #   team_games.each do |game|
    #     if game.game.is_completed
    #       season_tempo += game.game.possessions
    #       game_count += 1
    #     end
    #   end
    #   season.adj_tempo = season_tempo.to_f / game_count
    #   season.save
    #   team_seasons.reload
    #   current_season.adj_offensive_efficiency = team_seasons.average(:adj_offensive_efficiency)
    #   current_season.adj_defensive_efficiency = team_seasons.average(:adj_defensive_efficiency)
    #   current_season.adj_tempo = team_seasons.average(:adj_tempo)
    #   current_season.save
    #   current_season.reload
    # end
    # error_count = 0
    # oeff_error = 1000000
    # while oeff_error > 100000
    #   oeff_error = 0
    #   team_seasons.each do |season|
    #     team_games = TeamGame.where(team: season.team, season: current_season).order(day: :asc)
    #     adj_ortg_error = 0
    #     adj_drtg_error = 0
    #     adj_tempo_error = 0
    #     divisor = 0
    #     x = 0
    #     game_count = 0
    #     team_games.each do |game|
    #       if game.game.is_completed && game.wins + game.losses > 0 && game.minutes > 0
    #         competitiveness = 0
    #         opponent_season = TeamSeason.find_by(team: game.opponent, season: current_season)
    #         opponent_game = game.game.team_games.find_by(team: game.opponent)
    #         if season.adj_efficiency_margin && opponent_season.adj_efficiency_margin
    #           competitiveness = (2 / (1 + (season.adj_efficiency_margin - opponent_season.adj_defensive_efficiency) ** 2))
    #         end
    #         weight = 1 + (x * 0.3) + competitiveness
    #         if opponent_season && opponent_game && opponent_game.wins + opponent_game.losses > 0
    #           game_count += 1 
    #           expected_ortg = (season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (opponent_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency
    #           expected_drtg = (opponent_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_defensive_efficiency
    #           expected_tempo = (season.adj_tempo - current_season.adj_tempo) + (opponent_season.adj_tempo - current_season.adj_tempo) + current_season.adj_tempo
    #           if game.game.stadium == game.team.stadium
    #             expected_ortg += 2
    #             expected_drtg += -2
    #           elsif game.game.stadium == opponent_game.team.stadium
    #             expected_ortg += -2
    #             expected_drtg += 2
    #           end
    #           actual_ortg = 100 * game.points.to_f / game.game.possessions
    #           actual_drtg = 100 * opponent_game.points.to_f / game.game.possessions
    #           begin
    #             if game.minutes > 0
    #               actual_tempo = (200.0 / game.minutes) * game.game.possessions
    #               ## Margin of Victory capped at 30 points per 100 possessions
    #               if actual_ortg - actual_drtg > 30
    #                 actual_ortg = ((actual_ortg + actual_drtg)/ 2 ) + 15
    #                 actual_drtg = ((actual_ortg + actual_drtg)/ 2 ) - 15
    #               end
    #               ## Margin of Defeat capped at 30 points per 100 possessions
    #               if actual_drtg - actual_ortg > 30
    #                 actual_ortg = ((actual_ortg + actual_drtg)/ 2 ) - 15
    #                 actual_drtg = ((actual_ortg + actual_drtg)/ 2 ) + 15
    #               end
    #               adj_ortg_error += weight * (actual_ortg - expected_ortg)
    #               adj_drtg_error += weight * (actual_drtg - expected_drtg)
    #               adj_tempo_error += weight * (actual_tempo - expected_tempo)
    #               x += 1
    #               divisor += weight
    #             end
    #           rescue
    #             error_count += 1
    #             puts error_count
    #           end
    #         end
    #       end
    #     end
    #     if game_count < 11
    #       divisor += 10 / (game_count + 1)
    #     end
    #     season.adj_offensive_efficiency = (season.adj_offensive_efficiency + (adj_ortg_error / divisor)).round(1)
    #     season.adj_defensive_efficiency = (season.adj_defensive_efficiency + (adj_drtg_error / divisor)).round(1)
    #     season.adj_tempo = (season.adj_tempo + (adj_tempo_error / divisor)).round(1)
    #     season.adj_efficiency_margin = ((season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (current_season.adj_defensive_efficiency - season.adj_defensive_efficiency)).round(1)
    #     season.save
    #     oeff_error += (adj_ortg_error ** 2).round(1)
    #   end
    #   team_seasons.reload
    #   current_season.adj_offensive_efficiency = team_seasons.average(:adj_offensive_efficiency)
    #   current_season.adj_defensive_efficiency = team_seasons.average(:adj_defensive_efficiency)
    #   current_season.adj_tempo = team_seasons.average(:adj_tempo)
    #   current_season.save
    #   current_season.reload
    #   puts oeff_error
    # end
    team_seasons.each do |season|
      games_array = []
      season.adjem_rank = TeamSeason.order(adj_efficiency_margin: :desc).pluck(:id).index(season.id) + 1

      #### Game by Game advantage calculations ####
      TeamGame.where(team: season.team, season: current_season).each do |game|
        if game.game.is_completed && game.wins + game.losses > 0 && game.minutes > 0
          opponent_season = TeamSeason.find_by(team: game.opponent, season: current_season)
          opponent_game = game.game.team_games.find_by(team: game.opponent)
          if opponent_season && opponent_game
            expected_ortg = (season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (opponent_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency
            expected_drtg = (opponent_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_defensive_efficiency
            actual_ortg = 100 * game.points.to_f / game.game.possessions
            actual_drtg = 100 * opponent_game.points.to_f / game.game.possessions
            pace = game.game.possessions * 40 / (game.minutes / 5)
            performance = ((actual_ortg - expected_ortg) + (expected_drtg - actual_drtg)) *( pace / 100 )
            
            if actual_ortg - actual_drtg > 30
              if performance > 10
                performance = 10
              end
            end
                  ## Performance capped at 10 over 30 points per 100 possessions
            if actual_drtg - actual_ortg > 30
              if performance < -10
                performance = -10
              end
            end
            if game.game.stadium == game.team.stadium
              home = true
            elsif game.game.stadium == opponent_season.team.stadium
              home = false
            end
            defensive_style = opponent_season.defensive_aggression / 10.0
            three_pointers_advantage = ((opponent_season.three_pointers_rate * 2) + opponent_season.three_pointers_percentage) / 10.0
            pace_advantage = opponent_season.adj_tempo
            assists_advantage = opponent_season.assists_percentage
            game_hash = { "performance" => performance, "home" => home, "defense" => defensive_style, 
                          "three_pointers" => three_pointers_advantage, "pace" => pace_advantage, "assists" => assists_advantage}
            games_array.push(game_hash)
            game.performance = performance
            if home == true
              game.home_away_neutral = "home"
            elsif home == false
              game.home_away_neutral = "away"
            else
              game.home_away_neutral = "neutral"
            end
            game.defensive_style_advantage = defensive_style
            game.three_pointers_advantage = three_pointers_advantage
            game.pace_advantage = pace_advantage
            game.assists_advantage = assists_advantage
            game.save
          end
        end
      end
      sum_performance = games_array.sum { |game| game["performance"] }
      game_count = games_array.size.to_f
      home_games = games_array.select {|game| game["home"] == true}
      away_games = games_array.select {|game| game["home"] == false}
      sum_product_defense = 0
      sum_defense_squared = 0
      sum_defense = 0
      sum_product_threes = 0
      sum_threes_squared = 0
      sum_threes = 0
      sum_product_pace = 0
      sum_pace_squared = 0
      sum_pace = 0
      sum_product_assists = 0
      sum_assists_squared = 0
      sum_assists = 0
      games_array.each do |game|
        sum_product_defense += (game["defense"] * game["performance"])
        sum_defense_squared += (game["defense"]) ** 2
        sum_defense += game["defense"]
        sum_product_threes += (game["three_pointers"] * game["performance"])
        sum_threes_squared += (game["three_pointers"]) ** 2
        sum_threes += game["three_pointers"]
        sum_product_pace += (game["pace"] * game["performance"])
        sum_pace_squared += (game["pace"]) ** 2
        sum_pace += game["pace"]
        sum_product_assists += (game["assists"] * game["performance"])
        sum_assists_squared += (game["assists"]) ** 2
        sum_assists += game["assists"]
      end
            
      # Home Advantage Calcs
      home_advantage = home_games.sum { |game| game["performance"] } / home_games.size.to_f
      away_advantage = away_games.sum { |game| game["performance"] } / away_games.size.to_f
      
      # Style Advantage Calcs
      defensive_style_advantage = ((game_count * sum_product_defense) - (sum_defense * sum_performance.to_f)) / ((game_count * sum_defense_squared.to_f) - (sum_defense) ** 2)
      three_pointers_advantage = ((game_count * sum_product_threes) - (sum_threes * sum_performance.to_f)) / ((game_count * sum_threes_squared.to_f) - (sum_threes) ** 2)
      pace_advantage = ((game_count * sum_product_pace) - (sum_pace * sum_performance.to_f)) / ((game_count * sum_pace_squared.to_f) - (sum_pace) ** 2)
      assists_advantage = ((game_count * sum_product_assists) - (sum_assists * sum_performance.to_f)) / ((game_count * sum_assists_squared.to_f) - (sum_assists) ** 2)
      
      season.home_advantage = ((home_advantage - away_advantage)/2).round(1)
      season.defensive_style_advantage = defensive_style_advantage.round(2)
      season.three_pointers_advantage = three_pointers_advantage.round(2)
      season.pace_advantage = pace_advantage.round(2)
      season.assists_advantage = assists_advantage.round(2)
      season.save
    end
  end
end