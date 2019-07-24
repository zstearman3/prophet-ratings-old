require 'net/http'
require "#{Rails.root}/app/helpers/gaussian"
include Gaussian

namespace :calcs do
  task game_stats: :environment do
    puts("Please Input Year:")
    year_input = STDIN.gets.chomp.to_i
    current_season = Season.find_by(season: year_input)
    games = Game.where(season: current_season)
    games.each do |game|
      if game.status == "Final" || game.status == "F/OT"
        game.is_completed = true
        home_team_game = game.team_games.find_by(home_or_away: "HOME")
        away_team_game = game.team_games.find_by(home_or_away: "AWAY")
        if home_team_game && away_team_game
          begin
          if home_team_game.field_goals_attempted > 10 && away_team_game.field_goals_attempted > 10
            game.possessions = (0.5 * ((home_team_game.field_goals_attempted + (0.475 * home_team_game.free_throws_attempted) - home_team_game.offensive_rebounds  + home_team_game.turnovers) + (away_team_game.field_goals_attempted + 
            (0.475 * away_team_game.free_throws_attempted) - away_team_game.offensive_rebounds + away_team_game.turnovers))).round(1)
            game.home_offensive_efficiency = ((100 * game.home_team_score) / game.possessions).round(1)
            game.away_offensive_efficiency = ((100 * game.away_team_score) / game.possessions).round(1)
            game.pace = (40 * game.possessions / ((home_team_game.minutes + away_team_game.minutes) / 10)).round(1)
            game.save
          else
            game.possessions = nil
            game.home_offensive_efficiency = nil
            game.away_offensive_efficiency = nil
            game.pace = nil
            game.save
          end
          rescue
          
          end
        end
      end
    end
  end
  
  task season_stats: :environment do
    puts("Please Input Year:")
    year_input = STDIN.gets.chomp.to_i
    current_season = Season.find_by(season: year_input)
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
      season_free_throws_made = 0
      season_free_throws_made_allowed = 0
      season_field_goals_attempted = 0
      season_free_throws_attempted_allowed = 0
      season_blocked_shots = 0
      season_two_pointers_attempted = 0
      season_blocked_shots_allowed = 0
      season_two_pointers_attempted_allowed = 0
      season_steals = 0
      season_steals_allowed = 0
      season_three_pointers = 0
      season_three_pointers_attempted = 0
      season_three_pointers_attempted_allowed = 0
      season_assists = 0
      season_assists_allowed = 0
      season_field_goals = 0
      season_points = 0
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
          season_free_throws_made += game.free_throws_made
          season_field_goals_attempted += game.field_goals_attempted
          season_three_pointers += game.three_pointers_made
          season_three_pointers_attempted += game.three_pointers_attempted
          season_field_goals += game.field_goals_made
          season_assists += game.assists
          season_points += game.points
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
            season_free_throws_made_allowed += opponent_game.free_throws_made
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
      season.effective_field_goals_percentage = (100 * ((season_field_goals.to_f + (0.5 * season_three_pointers)) / season_field_goals_attempted.to_f)).round(1)
      season.effective_field_goals_percentage_allowed = (100 * (season_field_goals_allowed + (0.5 * season_three_pointers_allowed)) / season_field_goals_attempted_allowed.to_f).round(1)
      season.turnovers_percentage = (100 * season_turnovers.to_f / season_possessions).round(1)
      season.turnovers_percentage_allowed = (100 * season_turnovers_allowed.to_f / season_possessions_allowed).round(1)
      season.offensive_rebounds_percentage = (100 * season_offensive_rebounds.to_f / (season_offensive_rebounds + season_defensive_rebounds_allowed)).round(1)
      season.defensive_rebounds_percentage = (100 * season_defensive_rebounds.to_f / (season_defensive_rebounds + season_offensive_rebounds_allowed)).round(1)
      season.total_rebounds_percentage = (100 * (season_offensive_rebounds.to_f + season_defensive_rebounds) / (season_offensive_rebounds + season_defensive_rebounds + season_offensive_rebounds_allowed + season_defensive_rebounds_allowed)).round(1)
      season.free_throws_rate = (100 * season_free_throws_made.to_f / season_field_goals_attempted).round(1)
      season.free_throws_rate_allowed = (100 * season_free_throws_made_allowed / season_field_goals_attempted_allowed).round(1)
      season.blocks_percentage = (100 * season_blocked_shots.to_f / season_two_pointers_attempted_allowed).round(1)
      season.blocks_percentage_allowed = (100 * season_blocked_shots_allowed.to_f / season_two_pointers_attempted).round(1)
      season.steals_percentage = (100 * season_steals.to_f / season_possessions_allowed).round(1)
      season.steals_percentage_allowed = (100 * season_steals_allowed.to_f / season_possessions_allowed).round(1)
      season.three_pointers_rate = (100 * season_three_pointers_attempted.to_f / season_field_goals_attempted).round(1)
      season.three_pointers_rate_allowed = (100 * season_three_pointers_attempted_allowed.to_f / season_field_goals_attempted_allowed).round(1)
      season.assists_percentage = (100 * season_assists.to_f / season_field_goals).round(1)
      season.assists_percentage_allowed = (100 * season_assists_allowed.to_f / season_field_goals_allowed).round(1)
      season.true_shooting_percentage = (100 * season_points / (2 * (season_field_goals_attempted + (0.44 * season_free_throws_attempted)))).round(1)
      season.true_shooting_percentage_allowed = (100 * season_points_allowed / (2 * (season_field_goals_attempted_allowed + (0.44 * season_free_throws_attempted_allowed)))).round(1)
      season.three_pointers_proficiency = (((season.three_pointers_rate * 2) + season.three_pointers_percentage) / 10.0).round(1)
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
    current_season.three_pointers_proficiency = team_seasons.average(:three_pointers_proficiency)
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
    puts("Please Input Year:")
    year_input = STDIN.gets.chomp.to_i
    current_season = Season.find_by(season: year_input)
    team_seasons = TeamSeason.where(season: current_season)
    puts("Initial Run? (y/n)")
    initial_input = STDIN.gets.chomp
    if initial_input == "y"
      team_seasons.each do |season|
        season.adj_offensive_efficiency = season.offensive_efficiency
        season.adj_defensive_efficiency = season.defensive_efficiency
        season_tempo = 0
        team_games = TeamGame.where(team: season.team, season: current_season).order(day: :asc)
        game_count = 0
        team_games.each do |game|
          if game.game.is_completed && game.game.possessions
            season_tempo += game.game.possessions
            game_count += 1
          end
        end
        season.adj_tempo = season_tempo.to_f / game_count
        season.save
        team_seasons.reload
        current_season.adj_offensive_efficiency = team_seasons.average(:adj_offensive_efficiency)
        current_season.adj_defensive_efficiency = team_seasons.average(:adj_defensive_efficiency)
        current_season.adj_tempo = team_seasons.average(:adj_tempo)
        current_season.save
        current_season.reload
      end
    end
    error_count = 0
    oeff_error = 1000000
    while oeff_error > 100000
      oeff_error = 0
      team_seasons.each do |season|
        team_games = TeamGame.where(team: season.team, season: current_season).order(day: :asc)
        adj_ortg_error = 0
        adj_drtg_error = 0
        adj_tempo_error = 0
        divisor = 0
        x = 0
        game_count = 0
        team_games.each do |game|
          if game.game.is_completed && game.wins + game.losses > 0 && game.minutes > 0 && !game.opponent.nil? && !game.game.possessions.nil?
            competitiveness = 0
            opponent_season = TeamSeason.find_by(team: game.opponent, season: current_season)
            opponent_game = game.game.team_games.find_by(team: game.opponent)
            if season.adj_efficiency_margin && opponent_season && opponent_season.adj_efficiency_margin
              competitiveness = (30 / (20 + (season.adj_efficiency_margin - opponent_season.adj_efficiency_margin) ** 2))
            end
            weight = 1 + (x * 0.03) + competitiveness
            if opponent_season && opponent_game && opponent_game.wins + opponent_game.losses > 0
              game_count += 1 
              expected_ortg = (season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (opponent_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency
              expected_drtg = (opponent_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_defensive_efficiency
              expected_tempo = (season.adj_tempo - current_season.adj_tempo) + (opponent_season.adj_tempo - current_season.adj_tempo) + current_season.adj_tempo
              if game.game.stadium == game.team.stadium
                expected_ortg += 2
                expected_drtg += -2
              elsif game.game.stadium == opponent_game.team.stadium
                expected_ortg += -2
                expected_drtg += 2
              end
              actual_ortg = 100 * game.points.to_f / game.game.possessions
              actual_drtg = 100 * opponent_game.points.to_f / game.game.possessions
              begin
                if game.minutes > 0
                  actual_tempo = (200.0 / game.minutes) * game.game.possessions
                  ## Margin of Victory capped at 30 points per 100 possessions
                  if actual_ortg - actual_drtg > 30
                    actual_ortg = ((actual_ortg + actual_drtg)/ 2 ) + 15
                    actual_drtg = ((actual_ortg + actual_drtg)/ 2 ) - 15
                  end
                  ## Margin of Defeat capped at 30 points per 100 possessions
                  if actual_drtg - actual_ortg > 30
                    actual_ortg = ((actual_ortg + actual_drtg)/ 2 ) - 15
                    actual_drtg = ((actual_ortg + actual_drtg)/ 2 ) + 15
                  end
                  adj_ortg_error += weight * (actual_ortg - expected_ortg)
                  adj_drtg_error += weight * (actual_drtg - expected_drtg)
                  adj_tempo_error += weight * (actual_tempo - expected_tempo)
                  x += 1
                  divisor += weight
                end
              rescue
                error_count += 1
                puts error_count
              end
            end
          end
        end
        if game_count < 11
          divisor += 10 / (game_count + 1)
        end
        season.adj_offensive_efficiency = (season.adj_offensive_efficiency + (adj_ortg_error / divisor)).round(1)
        season.adj_defensive_efficiency = (season.adj_defensive_efficiency + (adj_drtg_error / divisor)).round(1)
        season.adj_tempo = (season.adj_tempo + (adj_tempo_error / divisor)).round(1)
        season.adj_efficiency_margin = ((season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (current_season.adj_defensive_efficiency - season.adj_defensive_efficiency)).round(1)
        season.save
        oeff_error += (adj_ortg_error ** 2).round(1)
      end
      team_seasons.reload
      current_season.adj_offensive_efficiency = team_seasons.average(:adj_offensive_efficiency)
      current_season.adj_defensive_efficiency = team_seasons.average(:adj_defensive_efficiency)
      current_season.adj_tempo = team_seasons.average(:adj_tempo)
      current_season.save
      current_season.reload
      puts oeff_error
    end
    team_seasons.each do |season|
      games_array = []
      season.adjem_rank = TeamSeason.where(season: current_season).order(adj_efficiency_margin: :desc).pluck(:id).index(season.id) + 1

      #### Game by Game advantage calculations ####
      ortg_array = []
      drtg_array = []
      TeamGame.where(team: season.team, season: current_season).each do |game|
        if game.game.is_completed && game.wins + game.losses > 0 && game.minutes > 0 && !game.opponent.nil? && !game.game.possessions.nil?
          opponent_season = TeamSeason.find_by(team: game.opponent, season: current_season)
          opponent_game = game.game.team_games.find_by(team: game.opponent)
          if opponent_season && opponent_game
            expected_ortg = (season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (opponent_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency
            expected_drtg = (opponent_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_defensive_efficiency
            actual_ortg = 100 * game.points.to_f / game.game.possessions
            actual_drtg = 100 * opponent_game.points.to_f / game.game.possessions
            ortg_array.push(actual_ortg - expected_ortg)
            drtg_array.push(actual_drtg - expected_drtg)
            pace = game.game.possessions * 40 / (game.minutes / 5)
            performance = ((actual_ortg - expected_ortg) + (expected_drtg - actual_drtg)) *( pace / 100 )
            
            if actual_ortg - actual_drtg > 30
              if performance > 15
                performance = 15
              end
            end
                  ## Performance capped at 10 over 30 points per 100 possessions
            if actual_drtg - actual_ortg > 30
              if performance < -15
                performance = -15
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
            game.performance = performance.round(1)
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
            game.effective_field_goals_percentage = (100 * (game.field_goals_made + (0.5 * game.three_pointers_made)) / game.field_goals_attempted.to_f).round(1)
            game.true_shooting_percentage = (100 * game.points / ( 2 * (game.field_goals_attempted + (0.44 * game.free_throws_attempted)))).round(1)
            game.free_throws_rate = (100 * game.free_throws_made.to_f / game.field_goals_attempted).round(1)
            game.pace = pace.round(1)
            game.blocks_percentage = ((100 * game.blocked_shots.to_f) / (opponent_game.field_goals_attempted - game.three_pointers_attempted)).round(1)
            game.steals_percentage = ((100 * game.steals) / game.game.possessions).round(1)
            game.assists_percentage = ((100 * game.assists.to_f) / game.field_goals_made).round(1)
            game.assists_percentage = 0.0 if game.assists_percentage.to_f.nan?
            game.assists_percentage = 100.0 if game.assits_percentage > 100.0
            game.turnovers_percentage = ((100 * game.turnovers) / game.game.possessions).round(1)
            game.offensive_efficiency = actual_ortg.round(1)
            game.defensive_efficiency = actual_drtg.round(1)
            game.expected_ortg = expected_ortg.round(1)
            game.expected_drtg = expected_drtg.round(1)
            game.offensive_rebounds_percentage = ((100 * game.offensive_rebounds.to_f) / (game.offensive_rebounds + opponent_game.defensive_rebounds)).round(1)
            game.defensive_rebounds_percentage = ((100 * game.defensive_rebounds.to_f) / (game.defensive_rebounds + opponent_game.offensive_rebounds)).round(1)
            begin
              game.save
            rescue
              ### Error handling ###
            end
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
      sum_product_assists = 0
      sum_assists_squared = 0
      sum_assists = 0
      sum_product_pace = 0
      sum_pace_squared = 0
      sum_pace = 0
      b_defensive_style = 0
      b_three_pointers = 0
      b_assists = 0
      b_pace = 0
      games_array.each do |game|
        sum_product_defense += (game["defense"] * game["performance"])
        sum_defense_squared += (game["defense"]) ** 2
        sum_defense += game["defense"]
        sum_product_threes += (game["three_pointers"] * game["performance"])
        sum_threes_squared += (game["three_pointers"]) ** 2
        sum_threes += game["three_pointers"]
        sum_product_assists += (game["assists"] * game["performance"])
        sum_assists_squared += (game["assists"]) ** 2
        sum_assists += game["assists"]
        sum_product_pace += (game["pace"] * game["performance"])
        sum_pace_squared += (game["pace"]) ** 2
        sum_pace += game["pace"]
      end
            
      # Home Advantage Calc
      home_advantage = home_games.sum { |game| game["performance"] } / home_games.size.to_f
      away_advantage = away_games.sum { |game| game["performance"] } / away_games.size.to_f
      
      # Defensive Style Advantage Calc
      defensive_style_advantage = ((game_count * sum_product_defense) - (sum_defense * sum_performance.to_f)) / ((game_count * sum_defense_squared.to_f) - (sum_defense) ** 2)
      b_defensive_style = (sum_performance / game_count ) - (defensive_style_advantage * (games_array.sum { |game| game["defense"]}) / game_count)
      
      three_pointers_advantage = ((game_count * sum_product_threes) - (sum_threes * sum_performance.to_f)) / ((game_count * sum_threes_squared.to_f) - (sum_threes) ** 2)
      b_three_pointers = (sum_performance / game_count ) - (three_pointers_advantage * (games_array.sum { |game| game["three_pointers"]}) / game_count)
      
      assists_advantage = ((game_count * sum_product_assists) - (sum_assists * sum_performance.to_f)) / ((game_count * sum_assists_squared.to_f) - (sum_assists) ** 2)
      b_assists = (sum_performance / game_count ) - (assists_advantage * (games_array.sum { |game| game["assists"]}) / game_count)
      
      pace_advantage = ((game_count * sum_product_pace) - (sum_pace * sum_performance.to_f)) / ((game_count * sum_pace_squared.to_f) - (sum_pace) ** 2)
      b_pace = (sum_performance / game_count ) - (pace_advantage * (games_array.sum { |game| game["pace"]}) / game_count)
      
      ssr_defensive_style = 0
      ssr_three_pointers = 0
      ssr_assists = 0
      ssr_pace = 0
      ssto = 0
      r_defensive_style = 0
      r_three_pointers = 0
      r_assists = 0
      r_pace = 0
      games_array.each do |game|
        ssr_defensive_style += (((defensive_style_advantage * game["defense"]) + b_defensive_style) - (sum_performance.to_f / game_count)) ** 2
        ssr_three_pointers += (((three_pointers_advantage * game["three_pointers"]) + b_three_pointers) - (sum_performance.to_f / game_count)) ** 2
        ssr_assists += (((assists_advantage * game["assists"]) + b_assists) - (sum_performance.to_f / game_count)) ** 2
        ssr_pace += (((pace_advantage * game["pace"]) + b_pace) - (sum_performance.to_f / game_count)) ** 2
        ssto += (game["performance"] - (sum_performance.to_f / game_count)) ** 2
      end
      ortg_avg = ortg_array.inject{ |sum, el| sum + el }.to_f / ortg_array.size
      drtg_avg = drtg_array.inject{ |sum, el| sum + el }.to_f / drtg_array.size
      ortg_squares = []
      drtg_squares = []
      ortg_array.each do |rating|
        ortg_squares.push((ortg_avg - rating) ** 2)
      end
      drtg_array.each do |rating|
        drtg_squares.push((drtg_avg - rating) ** 2)
      end
      ortg_stdev = Math.sqrt(ortg_squares.inject{ |sum, el| sum + el }.to_f / ortg_squares.size)
      drtg_stdev = Math.sqrt(drtg_squares.inject{ |sum, el| sum + el }.to_f / drtg_squares.size)
      season.consistency = (Math.sqrt(ortg_stdev * drtg_stdev)).round(1)
      r_defensive_style = (ssr_defensive_style.to_f / ssto).round(3)
      r_three_pointers = (ssr_three_pointers.to_f / ssto).round(3)
      r_assists = (ssr_assists.to_f / ssto).round(3)
      r_pace = (ssr_pace.to_f / ssto).round(3)
      season.r_defensive_style = r_defensive_style
      season.r_three_pointers = r_three_pointers
      season.r_assists = r_assists
      season.r_pace = r_pace
      season.home_advantage = ((home_advantage - away_advantage)/2).round(1)
      season.defensive_style_advantage = defensive_style_advantage.round(2)
      season.three_pointers_advantage = three_pointers_advantage.round(2)
      season.assists_advantage = assists_advantage.round(2)
      season.pace_advantage = pace_advantage.round(2)
      season.save
      team = season.team
      team.adj_offensive_efficiency = season.adj_offensive_efficiency
      team.adj_defensive_efficiency = season.adj_defensive_efficiency
      team.adj_efficiency_margin = season.adj_efficiency_margin
      team.adj_tempo = season.adj_tempo
      team.adjem_rank = season.adjem_rank
      team.save
    end
    team_seasons.reload
    current_season.adj_offensive_efficiency = team_seasons.average(:adj_offensive_efficiency)
    current_season.adj_defensive_efficiency = team_seasons.average(:adj_defensive_efficiency)
    current_season.adj_tempo = team_seasons.average(:adj_tempo)
    current_season.home_advantage = team_seasons.average(:home_advantage)
    current_season.consistency = team_seasons.average(:consistency)
    current_season.save
  end
  
  task advanced_player_stats: :environment do
    puts("Please Input Year:")
    year_input = STDIN.gets.chomp.to_i
    puts("Redo Completed Game Calcs (y/n/s/r)")
    puts "-s will skip games entirely, r will only edit seasons not edited in the last 5 days:"
    redo_input = STDIN.gets.chomp.downcase
    current_season = Season.find_by(season: year_input)
    player_games = PlayerGame.where(season: current_season)
    if redo_input == "y"
      player_games.update_all(bpm: nil)
      player_games.update_all(prophet_rating: nil)
    else
      player_games = player_games.where(bpm: nil)
    end
    count = player_games.count
    x = 0
    unless redo_input == "s" || redo_input == "r"
      player_games.each do |game|
        team_game = game.game.team_games.find_by(team: game.team)
        opponent_game = game.game.team_games.find_by(team: team_game.opponent) if !team_game.nil?
        if team_game && opponent_game
          team_season = TeamSeason.find_by(team: team_game.team, season: current_season)
          opponent_season = TeamSeason.find_by(team: opponent_game.team, season: current_season)
          if team_season && opponent_season
            if game.minutes > 0 && team_game.minutes > 0
              begin
                game.assists_percentage = ((100.0 * game.assists.to_f) / (((game.minutes / (team_game.minutes / 5.0)) * team_game.field_goals_made) - game.field_goals_made.to_f)).round(1)
                game.assists_percentage = 0.0 if game.assists_percentage.to_f.nan?
                game.assists_percentage = 100.0 if game.assits_percentage > 100.0
                game.offensive_rebounds_percentage = (100 * game.offensive_rebounds / (((game.minutes * 5.0) / team_game.minutes) * (team_game.offensive_rebounds + opponent_game.defensive_rebounds))).round(1)          
                game.defensive_rebounds_percentage = (100 * game.defensive_rebounds / (((game.minutes * 5.0) / team_game.minutes) * (team_game.defensive_rebounds + opponent_game.offensive_rebounds))).round(1)
                game.rebounds_percentage = (100 * game.rebounds / (((game.minutes * 5.0) / team_game.minutes) * (team_game.rebounds  + opponent_game.rebounds))).round(1)
                game.steals_percentage = (100 * game.steals / (((game.minutes * 5.0) / team_game.minutes) * game.game.possessions)).round(1)
                game.blocks_percentage = (100 * game.blocked_shots / ((( game.minutes * 5.0 ) / team_game.minutes) * (opponent_game.field_goals_attempted - opponent_game.three_pointers_attempted))).round(1)
                if !game.blocks_percentage.finite?
                  game.blocks_percentage = 0
                end
                game.turnovers_percentage = (100 * game.turnovers / ( game.field_goals_attempted + (0.44 * game.free_throws_attempted) + game.turnovers)).round(1)
                game.true_shooting_percentage = (100 * game.points.to_f / (2 * (game.field_goals_attempted + (0.44 * game.free_throws_attempted)))).round(1)
                game.effective_field_goals_percentage = (100 * (game.field_goals_made + (0.5 * game.three_pointers_made)) / game.field_goals_attempted).round(1)
                game.usage_rate = (100 * (game.field_goals_attempted + (0.44 * game.free_throws_attempted) + game.turnovers) / (((game.minutes * 5.0) / team_game.minutes) * game.game.possessions)).round(1)
                if game.minutes > 7
                  game.bpm = ((0.138 * game.minutes) + (0.1196 * game.offensive_rebounds_percentage) + (-0.1513 * game.defensive_rebounds_percentage) + (1.2556 * game.steals_percentage) + (0.5318 * game.blocks_percentage) +
                              (-0.3059 * game.assists_percentage) - (0.9213 * game.usage_rate * (game.turnovers_percentage / 100.0)) + ((0.7112 * game.usage_rate * (1 - (game.turnovers_percentage / 100.0))) * (2 * ((game.true_shooting_percentage / 100.0) - (team_game.true_shooting_percentage / 100.0)) +
                              (0.0170 * game.assists_percentage) + (0.2976 * ((game.three_pointers_attempted / ( game.field_goals_attempted * 100.0)) - (game.season.three_pointers_rate / 100.0))) - 0.2135)) + (0.7259 * (Math.sqrt(game.assists_percentage * game.rebounds_percentage)))).round(1)
                
                  if game.minutes < 24 
                    prate_minutes_multiplier = game.minutes / 24.0
                  else
                    prate_minutes_multiplier = 1
                  end
                  usage_adj = (game.usage_rate * (team_game.points.to_f / game.game.possessions) * (100.0 / opponent_season.adj_defensive_efficiency)) / 15.0
                  game.prophet_rating = ((game.bpm * prate_minutes_multiplier) + usage_adj).round(1)
                else
                  game.bpm = 0
                  game.prophet_rating = 0
                end
                game.save
              rescue StandardError => e
                puts e.message
              end
            end
          end
        end
        x += 1
        if x % 1000 == 0
          puts x.to_s + " of " + count.to_s + " games completed."
        end
      end
    end
    player_seasons = PlayerSeason.where(season: current_season)
    if redo_input == "r"
      player_seasons = player_seasons.where("updated_at < ?", 5.days.ago)
    end
    seasons_count = player_seasons.count
    i = 0
    player_seasons.each do |season|
      team_season = TeamSeason.find_by(team: season.team, season: current_season)
      if team_season.nil?
        next
      end
      offensive_rebounds = 0
      defensive_rebounds = 0
      rebounds = 0
      offensive_rebounds_allowed = 0
      defensive_rebounds_allowed = 0
      rebounds_allowed = 0
      team_offensive_rebounds = 0
      team_defensive_rebounds = 0
      team_rebounds = 0
      steals = 0
      blocked_shots = 0
      two_pointers_attempted_allowed = 0
      field_goals_attempted_allowed = 0
      three_pointers_attempted_allowed = 0
      three_pointers_attempted = 0
      team_field_goals_made = 0
      field_goals_made = 0
      three_pointers_made = 0
      free_throws_attempted = 0
      field_goals_attempted = 0
      free_throws_made = 0
      points = 0
      turnovers = 0
      assists = 0
      minutes = 0
      game_count = 0
      team_minutes = 0
      possessions = 0
      prophet_rating = 0
      fouls = 0
      vop = 1.1
      bpm = 0
      drbp = (season.season.defensive_rebounds_percentage / 100.0)
      factor = 0.475
      total_weight = 0
      games = PlayerGame.where(player: season.player, season: current_season)
      games.each do |game|
        team_game = game.game.team_games.find_by(team: game.team)
        opponent_game = game.game.team_games.find_by(team: team_game.opponent) if !team_game.nil?
        if team_game && opponent_game
          opponent_season = TeamSeason.find_by(team: opponent_game.team, season: current_season)
          if team_season && opponent_season
            if game.minutes > 0 && team_game.minutes > 0 && game.game.possessions
              offensive_rebounds += game.offensive_rebounds
              defensive_rebounds += game.defensive_rebounds
              offensive_rebounds_allowed += opponent_game.offensive_rebounds
              defensive_rebounds_allowed += opponent_game.defensive_rebounds
              team_offensive_rebounds += team_game.offensive_rebounds
              team_defensive_rebounds += team_game.defensive_rebounds
              steals += game.steals
              blocked_shots += game.blocked_shots
              field_goals_attempted_allowed += opponent_game.field_goals_attempted
              three_pointers_attempted_allowed += opponent_game.three_pointers_attempted
              field_goals_made += game.field_goals_made
              three_pointers_made += game.three_pointers_made
              three_pointers_attempted += game.three_pointers_attempted
              team_field_goals_made += team_game.field_goals_made
              assists += game.assists
              free_throws_attempted += game.free_throws_attempted
              free_throws_made += game.free_throws_made
              field_goals_attempted += game.field_goals_attempted
              turnovers += game.turnovers
              points += game.points
              minutes += game.minutes
              team_minutes += team_game.minutes
              possessions += game.game.possessions
              fouls += game.personal_fouls
              competitiveness = competitiveness = (30 / (20 + (team_season.adj_efficiency_margin - opponent_season.adj_efficiency_margin) ** 2))
              if game.minutes < 25
                minutes_multiplier = (game.minutes / 25.0)
              else
                minutes_multiplier = 1
              end
              weight =  (1 + competitiveness)
              if game.bpm 
                if game.bpm.finite? && game.qualified != true
                  bpm += game.bpm
                  total_weight += weight
                  competition = (opponent_season.adj_efficiency_margin / 6.5) + ((opponent_season.adj_efficiency_margin - team_season.adj_efficiency_margin) / 20.0 )
                  raw_prating = game.bpm + competition
                  adj_prating = minutes_multiplier * weight * raw_prating
                  prophet_rating += adj_prating
                else
                  game.qualified = true
                  game.bpm = 0
                  game.prophet_rating = 0
                  game.save
                end
              end
              game_count += 1
            end
          end
        end
      end
      minutes_percentage = minutes / (team_minutes / 5.0)
      game_percentage = game_count.to_f / team_season.games
      rebounds = offensive_rebounds + defensive_rebounds
      team_rebounds = team_offensive_rebounds + team_defensive_rebounds
      rebounds_allowed = offensive_rebounds_allowed + defensive_rebounds_allowed
      two_pointers_attempted_allowed = field_goals_attempted_allowed - three_pointers_attempted_allowed
      season.offensive_rebounds_percentage = ((100.0 * offensive_rebounds) / (minutes_percentage * (team_offensive_rebounds + defensive_rebounds_allowed))).round(1) 
      season.defensive_rebounds_percentage = ((100.0 * defensive_rebounds) / (minutes_percentage * (team_defensive_rebounds + offensive_rebounds_allowed))).round(1)
      season.total_rebounds_percentage = ((100.0 * rebounds) / (minutes_percentage * (team_rebounds + rebounds_allowed))).round(1)
      season.steals_percentage = ((100.0 * steals) / (minutes_percentage * possessions)).round(1)
      season.blocks_percentage = ((100.0 * blocked_shots) / (minutes_percentage * two_pointers_attempted_allowed)).round(1)
      season.assists_percentage = ((100.0 * assists) / ((minutes_percentage * team_field_goals_made) - field_goals_made)).round(1)
      season.turnovers_percentage = ((100.0 * turnovers) / (field_goals_attempted + (0.44 * free_throws_attempted) + turnovers)).round(1)
      season.effective_field_goals_percentage = ((100.0 * (field_goals_made + (0.5 * three_pointers_made))) / field_goals_attempted).round(1)
      season.true_shooting_percentage = (100.0 * points / (2 * (field_goals_attempted + (0.44 * free_throws_attempted)))).round(1)
      season.usage_rate = (100 * (field_goals_attempted + (0.44 * free_throws_attempted) + turnovers) / (minutes_percentage * possessions)).round(1)
      season.games_percentage = (100.0 * game_percentage).round(1)
      season.minutes_percentage = (100.0 * minutes_percentage).round(1)
      season.points_per_game = (points / game_count.to_f).round(1)
      season.rebounds_per_game = (rebounds / game_count.to_f).round(1)
      season.assists_per_game = (assists / game_count.to_f).round(1)
      season.steals_per_game = (steals / game_count.to_f).round(1)
      season.blocks_per_game = (blocked_shots / game_count.to_f).round(1)
      begin
        if minutes_percentage > 0.20 && game_percentage > 0.33
          uper = (1.0 / minutes) * (three_pointers_made + (0.6666 * assists) + (((2 - factor) * team_season.assists_percentage) * field_goals_made) + 
                 ((free_throws_made * 0.5) * (1 + (1 - team_season.assists_percentage) + (0.6666 * team_season.assists_percentage))) - (vop * turnovers) - (vop * drbp * (field_goals_attempted - field_goals_made)) -
                 (vop * 0.44 * (0.44 + (0.56 * drbp)) * (free_throws_attempted - free_throws_made)) + (vop * (1 - drbp) * defensive_rebounds) +
                 (vop * drbp * offensive_rebounds) + (vop * steals) + (vop * drbp * blocked_shots) - (fouls * (0.8 - (0.44 * vop))))
          season.aper = (current_season.adj_tempo / team_season.adj_tempo) * uper
          season.bpm = ((0.138 * (minutes.to_f / (game_count + 3))) + (0.1196 * season.offensive_rebounds_percentage) + (-0.1513 * season.defensive_rebounds_percentage) + (1.2556 * season.steals_percentage) + (0.5318 * season.blocks_percentage) +
                    (-0.3059 * season.assists_percentage) - (0.9213 * season.usage_rate * (season.turnovers_percentage / 100.0)) + ((0.7112 * season.usage_rate * (1 - (season.turnovers_percentage / 100.0))) * (2 * ((season.true_shooting_percentage / 100.0) - (team_season.true_shooting_percentage / 100.0)) +
                    (0.0170 * season.assists_percentage) + (0.2976 * ((three_pointers_attempted / (field_goals_attempted * 100.0)) - (current_season.three_pointers_rate / 100.0))) - 0.2135)) + (0.7259 * (Math.sqrt(season.assists_percentage * season.total_rebounds_percentage)))).round(1)
          if season.usage_rate < 22
            season.prophet_rating = (((season.usage_rate / 22.0) * prophet_rating) / total_weight).round(1)
          else
            season.prophet_rating = (prophet_rating / total_weight).round(1)
          end
          team_adjustment = ((season.usage_rate * minutes_percentage * team_season.adj_efficiency_margin) / 100.0).round(1)
          season.prophet_rating += team_adjustment
          season.save
        else
          season.prophet_rating = 0
          season.aper = nil
          season.player_efficiency_rating = nil
          season.bpm = nil
          season.save
        end
      rescue
      
      end
      i += 1
      if i % 100 == 0
        puts i.to_s + " of " + seasons_count.to_s + " seasons completed."
      end
    end
    player_seasons = PlayerSeason.where(season: current_season)
    games = Game.where(season: current_season)
    games.each do |game|
      player_game = game.player_games.where("minutes > ?", 22).order(prophet_rating: :desc).first
      game.player_of_the_game = player_game.player if player_game
      game.save
    end
    current_season.aper = player_seasons.average(:aper)
    current_season.save
    player_seasons.each do |season|
      if season.aper
        season.player_efficiency_rating = (season.aper * (15 / current_season.aper)).round(1)
        season.player_of_the_games = season.player.player_of_the_games.where(season: current_season).count
        season.save
      end
    end
  end
  
    
  task full_predictions: :environment do
    puts("Please Input Year:")
    year_input = STDIN.gets.chomp.to_i
    current_season = Season.find_by(season: year_input)
    season_games = Game.where(season: current_season)
    season_games.each do |game|
      home_team_season = TeamSeason.find_by(season: current_season, team: game.home_team)
      away_team_season = TeamSeason.find_by(season: current_season, team: game.away_team)
      if home_team_season && away_team_season
        home_advantage = 0
        defensive_advantage = 0
        assists_advantage = 0
        three_pointers_advantage = 0
        pace_advantage = 0
        injury_advantage = 0
        prediction = Prediction.find_or_create_by(game: game)
        prediction.season = current_season
        prediction.day = game.day
        prediction.point_spread = game.point_spread
        prediction.over_under = game.over_under
        prediction.moneyline = game.home_team_money_line
        predicted_tempo = (home_team_season.adj_tempo - current_season.adj_tempo) + (away_team_season.adj_tempo - current_season.adj_tempo) + current_season.adj_tempo
        predicted_home_efficiency = (home_team_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (away_team_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency
        predicted_away_efficiency = (away_team_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (home_team_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency        
        
        # Matchup Specific Modifiers
        if game.home_team.stadium == game.stadium
          home_advantage = (((4.0 * current_season.home_advantage) + home_team_season.home_advantage + away_team_season.home_advantage)/ 6.0).round(1)
          predicted_home_efficiency += home_advantage / 2.0
          predicted_away_efficiency += home_advantage / -2.0
        end
        
        if home_team_season.r_defensive_style > 0.1
          defensive_advantage += home_team_season.defensive_style_advantage * (home_team_season.r_defensive_style / 0.15) * (away_team_season.defensive_aggression / 10.0)
        end
        
        if away_team_season.r_defensive_style > 0.1
          defensive_advantage += -away_team_season.defensive_style_advantage * (away_team_season.r_defensive_style / 0.15) * (home_team_season.defensive_aggression / 10.0)
        end
        
        if home_team_season.r_assists > 0.1
          assists_advantage += home_team_season.assists_advantage * (home_team_season.r_assists / 0.15) * ((away_team_season.assists_percentage - current_season.assists_percentage) / 1.5)
        end
        
        if away_team_season.r_assists > 0.1
          assists_advantage += -away_team_season.assists_advantage * (away_team_season.r_assists / 0.15) * ((home_team_season.assists_percentage - current_season.assists_percentage) / 1.5)
        end
        
        if home_team_season.r_three_pointers > 0.1
          three_pointers_advantage += home_team_season.three_pointers_advantage * (home_team_season.r_three_pointers / 0.15) * ((away_team_season.three_pointers_proficiency - current_season.three_pointers_proficiency) / 1.1)
        end
        
        if away_team_season.r_three_pointers > 0.1
          three_pointers_advantage += -away_team_season.three_pointers_advantage * (away_team_season.r_three_pointers / 0.15) * ((home_team_season.three_pointers_proficiency - current_season.three_pointers_proficiency) / 1.1)
        end
        
        if home_team_season.r_pace > 0.1
          pace_advantage += home_team_season.pace_advantage * (home_team_season.r_pace   / 0.15) * ((away_team_season.adj_tempo - current_season.adj_tempo) / 1.1)
        end
        
        if away_team_season.r_pace > 0.1
          pace_advantage += -away_team_season.pace_advantage * (away_team_season.r_pace  / 0.15) * ((home_team_season.adj_tempo - current_season.adj_tempo) / 1.1)
        end
        defensive_advantage = 6.5 if defensive_advantage > 6.5
        assists_advantage = 6.5 if assists_advantage > 6.5
        three_pointers_advantage = 6.5 if three_pointers_advantage > 6.5
        pace_advantage = 6.5 if pace_advantage > 6.5
        defensive_advantage = -6.5 if defensive_advantage < -6.5
        assists_advantage = -6.5 if assists_advantage < -6.5
        three_pointers_advantage = -6.5 if three_pointers_advantage < -6.5
        pace_advantage = -6.5 if pace_advantage < -6.5
        predicted_home_efficiency += defensive_advantage / 2.0
        predicted_away_efficiency += defensive_advantage / -2.0
        predicted_home_efficiency += assists_advantage / 2.0
        predicted_away_efficiency += assists_advantage / -2.0
        predicted_home_efficiency += three_pointers_advantage / 2.0
        predicted_away_efficiency += three_pointers_advantage / -2.0
        predicted_home_efficiency += pace_advantage / 2.0
        predicted_away_efficiency += pace_advantage / -2.0
        begin
          prediction.home_advantage = home_advantage.round(1)
          prediction.defense_advantage = defensive_advantage.round(1)
          prediction.assists_advantage = assists_advantage.round(1)
          prediction.three_pointers_advantage = three_pointers_advantage.round(1)
          prediction.pace_advantage = pace_advantage.round(1)
          predicted_home_score = predicted_home_efficiency * predicted_tempo / 100
          predicted_away_score = predicted_away_efficiency * predicted_tempo / 100
          prediction.home_team_prediction = predicted_home_score.round
          prediction.away_team_prediction = predicted_away_score.round
          prediction.predicted_point_spread = (((predicted_away_score - predicted_home_score) * 2).round / 2.0)
          prediction.predicted_over_under = (((predicted_away_score + predicted_home_score) * 2).round / 2.0)
        rescue
          puts prediction.inspect
        end
        begin
          if game.home_team_score && game.away_team_score && prediction.point_spread && prediction.predicted_point_spread
            ### POINT SPREAD OUTCOME ####
            if prediction.predicted_point_spread < (prediction.point_spread - 1)
              # home team bet
              if (game.away_team_score - game.home_team_score) < prediction.point_spread
                # winning bet
                prediction.win_point_spread = true
                prediction.winnings_point_spread = 90.9
              elsif (game.away_team_score - game.home_team_score) > prediction.point_spread
                # losing bet
                prediction.win_point_spread = false
                prediction.winnings_point_spread = -100
              else
                prediction.win_point_spread = nil
              end
            elsif prediction.predicted_point_spread > (prediction.point_spread + 1)
              if (game.away_team_score - game.home_team_score) > prediction.point_spread
                # winning bet
                prediction.win_point_spread = true
                prediction.winnings_point_spread = 90.9
              elsif (game.away_team_score - game.home_team_score) < prediction.point_spread
                # losing bet
                prediction.win_point_spread = false
                prediction.winnings_point_spread = -100
              else
                prediction.win_point_spread = nil
              end
            else
              # no bet
              prediction.win_point_spread = nil
            end
          end
        
          if game.home_team_score && game.away_team_score && prediction.over_under && prediction.predicted_over_under
            ### OVER/UNDER OUTCOME ###
            if prediction.predicted_over_under > (prediction.over_under + 1)
              # over bet
              if (game.away_team_score + game.home_team_score) < prediction.over_under
                # winning bet
                prediction.win_over_under = true
                prediction.winnings_over_under = 90.9
              elsif (game.away_team_score + game.home_team_score) < prediction.over_under
                # losing bet
                prediction.win_over_under = fals
                prediction.winnings_over_under = -100
              else
                prediction.win_over_under = nil
              end
            elsif prediction.predicted_over_under < (prediction.over_under - 1)
            # under bet
              if (game.away_team_score + game.home_team_score) < prediction.over_under
                # winning bet
                prediction.win_over_under = true
                prediction.winnings_over_under = 90.9
              elsif (game.away_team_score + game.home_team_score) > prediction.over_under
                # losing bet
                prediction.win_over_under = false
                prediction.winnings_over_under = -100
              else
                prediction.win_over_under = nil
              end
            else
              # no bet
              prediction.win_over_under = nil
            end
          end
        
          ### STRAIGHT UP OUTCOME ###
          if prediction.home_team_prediction && prediction.away_team_prediction && game.home_team_score && game.away_team_score
            if prediction.home_team_prediction > (prediction.away_team_prediction + 1)
              if game.home_team_score > game.away_team_score
                prediction.win_straight_up = true
              else
                prediction.win_straight_up = false
              end
            elsif prediction.home_team_prediction < (prediction.away_team_prediction - 1)
              if game.away_team_score > game.home_team_score
                prediction.win_straight_up = true
              else
                prediction.win_straight_up = false
              end
            else
              prediction.win_straight_up = nil
            end
          end
        
          ##### MONEYLINE CALCS ######
          mean = predicted_home_efficiency - predicted_away_efficiency
          std_dev = current_season.consistency
          home_win_z_score = (0.0 - mean) / std_dev
          home_win_probability = getProbability(home_win_z_score)
          prediction.home_win_probability = (home_win_probability * 100.0).round(1)
          if home_win_probability > 0.5
            predicted_moneyline = (- (home_win_probability / (1 - home_win_probability)) * 100.0).round
            if predicted_moneyline < -10000
              prediction.predicted_moneyline = nil
            else
              prediction.predicted_moneyline = (predicted_moneyline / 10.0).round * 10
            end
          else
            predicted_moneyline = (((1 - home_win_probability) / home_win_probability) * 100.0).round
            if predicted_moneyline > 10000
              prediction.predicted_moneyline = nil
            else
              prediction.predicted_moneyline = (predicted_moneyline / 10.0).round * 10
            end
          end
        
          ### MONEYLINE UP OUTCOME ###
          if prediction.predicted_moneyline && prediction.moneyline && game.home_team_score && game.away_team_score
            if prediction.moneyline < 0
              ### HOME TEAM FAVORED ###
              if prediction.predicted_moneyline < (prediction.moneyline * 1.2)
                ### HOME TEAM BET ###
                if game.home_team_score > game.away_team_score
                  prediction.win_moneyline = true
                  prediction.winnings_moneyline = (100.0 / (game.home_team_money_line / -100.0)).round(2)
                else
                  prediction.win_moneyline = false
                  prediction.winnings_moneyline = -100.0
                end
              elsif prediction.predicted_moneyline > (prediction.moneyline / 1.2)
                ### AWAY TEAM BET ###
                if game.away_team_score > game.home_team_score
                  prediction.win_moneyline = true
                  prediction.winnings_moneyline = (100.0 * (game.away_team_money_line / 100.0)).round(2)
                else
                  prediction.win_moneyline = false
                  prediction.winnings_moneyline = -100.0
                end
              else
                prediction.win_moneyline = nil
                prediction.winnings_moneyline = 0
              end
            else
              ### AWAY TEAM FAVORED ###
              if prediction.predicted_moneyline < (game.home_team_money_line / 1.2)
                ### HOME TEAM BET ###
                if game.home_team_score > game.away_team_score
                  prediction.win_moneyline = true
                  prediction.winnings_moneyline = (100.0 * (game.home_team_money_line / 100.0)).round(2)
                else
                  prediction.win_moneyline = false
                  prediction.winnings_moneyline = -100.0
                end
              elsif prediction.predicted_moneyline > (game.home_team_money_line * 1.2)
                ### AWAY TEAM BET ###
                if game.away_team_score > game.home_team_score
                  prediction.win_moneyline = true
                  prediction.winnings_moneyline = (100.0 / (game.away_team_money_line / -100.0)).round(2)
                else
                  prediction.win_moneyline = false
                  prediction.winnings_moneyline = -100.0
                end
              else
                prediction.win_moneyline = nil
                prediction.winnings_moneyline = 0
              end
            end
          end
        rescue
          # Prediction calculations failed #
        end
        
        if prediction.home_team_prediction && prediction.away_team_prediction && prediction.home_team_prediction > 0 && prediction.away_team_prediction > 0
          prediction.save
        end
      end
    end
  end
  
  task gaussian_test: :environment do
    puts getProbability(-1.76)
  end
  
  task generate_preseason: :environment do
    team_seasons = TeamSeason.where(year: 2019)
    team_seasons.each do |season|
      new_season = TeamSeason.find_or_create_by(team: season.team, year: 2020)
      new_season.season = Season.find_by(season: 2020)
      new_season.save
    end

    ## Create players who sat out 2019 ##
    all_players = Player.where(active: true)
    transfer_players = []
    all_players.each do |player|
      if player.player_seasons.where(year: 2019).empty?
        transfer_players << player
      end
    end
    transfer_players.each do |player|
      new_player_season = PlayerSeason.find_by(player: player, year: 2020)
      if new_player_season.nil?
        new_player_season = PlayerSeason.new(player: player, year: 2020)
        old_player_season = PlayerSeason.find_by(player: player, year: 2018)
        if old_player_season
          new_player_season.team = player.team
          new_player_season.name = old_player_season.name
          new_player_season.team_name = player.team.school
          if !old_player_season.prophet_rating.nan? && !old_player_season.usage_rate.nan?
            new_player_season.prophet_rating = old_player_season.prophet_rating + 0.65
            new_player_season.usage_rate = old_player_season.usage_rate
          else
            new_player_season.prophet_rating = 0.0
            new_player_season.usage_rate = 0.0
          end
          if new_player_season.save
            next
          else
            new_player_season.errors.full_messages.each do |msg|
              puts msg
            end
          end
        end
      end
    end

    #### Create players who played 2019... Already done. Don't want to rerun #######
    # player_seasons = PlayerSeason.where(year: 2019)
    # player_seasons.each do |season|
    #   new_player_season = PlayerSeason.find_by(player: season.player, year: 2020)
    #   if new_player_season.nil?
    #     new_player_season = PlayerSeason.new(player: season.player, year: 2020)
    #     new_player_season.season = Season.find_by(season: 2020)
    #     new_player_season.name = season.name
    #     new_player_season.team_name = season.team_name
    #     new_player_season.prophet_rating = season.prophet_rating.to_f + 0.65
    #     new_player_season.team = season.team
    #     if new_player_season.save
    #       next
    #     else
    #       new_player_season.errors.full_messages.each do |msg|
    #         puts msg
    #       end
    #     end
    #   end
    # end
  end
  
  task preseason_ratings: :environment do
    s = Season.find_by(season: 2019)
    avg_adjo = s.adj_offensive_efficiency
    avg_adjd = s.adj_defensive_efficiency
    avg_adjt = s.adj_tempo
    Team.all.each do |team|
      avg_adjem = TeamSeason.where(team: team).average(:adj_efficiency_margin)
      new_season = TeamSeason.find_by(team: team, year: 2020)
      old_season = TeamSeason.find_by(team: team, year: 2019)
      total_value = ((old_season.adj_efficiency_margin / 5.0 ) + 2.0) * 200.0
      standard_value = ((avg_adjem / 5.0) + 1.5)
      next if new_season.nil? || old_season.nil?
      old_adjo = old_season.adj_offensive_efficiency
      old_adjd = old_season.adj_defensive_efficiency
      old_adjt = old_season.adj_tempo
      old_adjem = old_season.adj_efficiency_margin
      
      # get value lost
      usage_lost = 0
      value_lost = 0
      total_player_value = 0
      players = PlayerSeason.where(team: team, year: 2019)
      players.each do |player|
        if !player.usage_rate.nan? && !player.minutes_percentage.nan? && !player.games_percentage.nan? && !player.prophet_rating.nan?
          total_player_value += (player.usage_rate / 100.0) * player.minutes_percentage * (player.games_percentage / 100.0)  * player.prophet_rating
        end
      end
      players.each do |player|
        new_player = PlayerSeason.find_by(player: player.player, team: team, year: 2020)
        if new_player.nil?
          if !player.usage_rate.nan? && !player.minutes_percentage.nan? && !player.games_percentage.nan? && !player.prophet_rating.nan?
            if player.prophet_rating > standard_value
              usage_lost += (player.usage_rate / 100.0) * player.minutes_percentage * (player.games_percentage / 100.0)
              player_value = (player.usage_rate / 100.0) * player.minutes_percentage * (player.games_percentage / 100.0)  * player.prophet_rating
              value_lost += (((player_value / total_player_value) * total_value) + (player_value)) / 2.0
            else
              usage_lost += (player.usage_rate / 100.0) * player.minutes_percentage * (player.games_percentage / 100.0)
              player_value = (player.usage_rate / 100.0) * player.minutes_percentage * (player.games_percentage / 100.0)  * standard_value
              value_lost += (((player_value / total_player_value) * total_value) + (player_value)) / 2.0
            end
          end
        end
      end
      
      ## calculate value added by new players, transfers, current player improvement
      usage_gained = 0
      value_gained = 0
      total_new_value = 0
      total_new_usage = 0
      new_players = PlayerSeason.where(team: team, year: 2020)
      new_players.each do |player|
        old_player = PlayerSeason.find_by(player: player.player, year: 2019)
        two_old = PlayerSeason.find_by(player: player.player, year: 2018)
        if old_player.nil? && two_old.nil?
          # top 75 recruit
          # 16 - (4.0 * log(RK))
          player_usage = 0.25 * 60
          usage_gained += (0.25) * (60)
          recruit_value = ((0.25) * 60.0 * player.prophet_rating)
          recruit_value = standard_value if recruit_value < standard_value
          value_gained += recruit_value
          player_weight_value = recruit_value
          player_weight_usage = player_usage
          player.preseason_description = "recruit"
        elsif old_player && old_player.team != team
          # immediate transfer
          if !old_player.usage_rate.to_f.nan? && !old_player.minutes_percentage.to_f.nan? && !old_player.prophet_rating.to_f.nan?
            old_team_em = TeamSeason.find_by(team: old_player.team, year: 2019).adj_efficiency_margin
            team_modifier = 1 - ((old_team_em - old_adjem) / 50)
            player_value = (old_player.prophet_rating.to_f + 0.65)
            player_value = standard_value if player_value < standard_value
            player_usage = (old_player.usage_rate.to_f / 100.0) * (old_player.minutes_percentage.to_f) * team_modifier
            usage_gained += player_usage
            transfer_value = (player_value * player_usage)
            value_gained += transfer_value
            player_weight_value = transfer_value
            player_weight_usage = player_usage
            player.preseason_description = "transfer"
          end
        elsif two_old && two_old.team != team
          # transfer sat out
          if !two_old.usage_rate.to_f.nan? && !two_old.minutes_percentage.to_f.nan? && !two_old.prophet_rating.to_f.nan?
            two_old_season = TeamSeason.find_by(team: two_old.team, year: 2018)
            if two_old_season
              old_team_em = two_old_season.adj_efficiency_margin
              team_modifier = 1 - ((old_team_em - old_adjem) / 50)
            else
              team_modifier = 1
            end
            player_value = (two_old.prophet_rating.to_f + 0.85)
            player_value = standard_value if player_value < standard_value
            player_usage = (two_old.usage_rate.to_f / 100.0) * (two_old.minutes_percentage.to_f) * team_modifier
            usage_gained += player_usage
            transfer_2_value = (player_value * player_usage)
            player_weight_value = transfer_2_value
            player_weight_usage = player_usage
            value_gained += transfer_2_value
            player.preseason_description = "transfer"
          end
        elsif (old_player.nil? && two_old) || (!old_player.usage_rate.nan? && !old_player.minutes_percentage.nan? && !old_player.prophet_rating.nan?)
          old_player = two_old if old_player.nil?
          if old_player.games_percentage < 70 && old_player.usage_rate > 20 && old_player.minutes_percentage > 20 && old_player.prophet_rating > 2
        ## returning injured player
            player_usage = ((old_player.usage_rate / 100.0) * (old_player.minutes_percentage) * (1-(old_player.games_percentage / 100.0)))
            usage_gained += player_usage
            if (old_player.prophet_rating.to_f + 0.85) > standard_value
              injury_value = ((old_player.usage_rate / 100.0) * (old_player.minutes_percentage) * (1-(old_player.games_percentage / 100.0)) * (old_player.prophet_rating.to_f + 0.85))
            else
              injury_value = ((old_player.usage_rate / 100.0) * (old_player.minutes_percentage) * (1-(old_player.games_percentage / 100.0)) * (standard_value))
            end
            value_gained += injury_value
            player_weight_value = injury_value
            player_weight_usage = player_usage
            player.preseason_description = "injury"
          elsif !old_player.usage_rate.to_f.nan? && !old_player.minutes_percentage.to_f.nan? && !old_player.prophet_rating.to_f.nan?
            # Returning Player Improvement
            improvement_value = ((old_player.usage_rate.to_f / 100.0) * old_player.minutes_percentage.to_f * 0.85)
            value_gained +=  improvement_value
            player.preseason_description = "improvement"
            player_weight_usage = ((old_player.usage_rate.to_f / 100.0) * old_player.minutes_percentage.to_f)
            player_weight_value = ((old_player.usage_rate.to_f / 100.0) * old_player.minutes_percentage.to_f) * old_player.prophet_rating
          end
        end
        total_new_usage += player_weight_usage if player_weight_usage
        total_new_value += player_weight_value if player_weight_value
        player.save
      end
      standard_value = (2.0 * standard_value + (total_new_value.to_f / total_new_usage)) / 3.0
      ## Replacement level players
      if usage_gained > usage_lost
        value_gained = value_gained * (usage_lost / usage_gained)
      else
        usage_remaining = usage_lost - usage_gained
        replacement_value = (standard_value * usage_remaining)
        value_gained += replacement_value
        puts "Replacement Value: " + replacement_value.to_s if replacement_value > 0
      end
      puts team.school if usage_lost > 0
      puts total_value if usage_lost > 0
      puts "Usage Lost: " + usage_lost.to_s if usage_lost > 0
      puts "Value Lost: " + value_lost.to_s if value_lost > 0
      puts "Usage gained: " + usage_gained.to_s if usage_lost > 0
      puts "Value gained: " + value_gained.to_s if value_lost > 0
      new_value = total_value - value_lost + value_gained
      new_adj_em = ((new_value / 200.0) - 2.0) * 5.0
      em_change = new_adj_em - old_season.adj_efficiency_margin
      new_season.adj_offensive_efficiency = (old_adjo + (em_change / 2.0)).round(1)
      new_season.adj_defensive_efficiency = (old_adjd - (em_change / 2.0)).round(1)
      new_season.adj_tempo = old_adjt.round(1)
      new_season.adj_efficiency_margin = new_adj_em.round(1)
      new_season.initial_adj_o = new_season.adj_offensive_efficiency
      new_season.initial_adj_d = new_season.adj_defensive_efficiency
      new_season.initial_adj_t = new_season.adj_tempo
      new_season.save
    end
    TeamSeason.where(year: 2020).each do |season|
      season.adjem_rank = TeamSeason.where(year: 2020).order(adj_efficiency_margin: :desc).pluck(:id).index(season.id) + 1
      season.save
    end
  end
end