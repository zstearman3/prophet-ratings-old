require 'net/http'

namespace :daily do
  api_key = '771069411cbf42f4bbb07001c1a741fc'
  current_year = '2020'
  desc "Chron tasks to update database"
  task downloads: :environment do
    # Get heirarchy
    url = URI.parse('https://api.fantasydata.net/api/cbb/fantasy/json/LeagueHierarchy?key=' + api_key)
    puts 'Starting downloads'
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
      http.request(req)
    end
    json_res =  res.body
    obj = JSON.parse(json_res)
    obj.each do |conf|
      conf['Teams'].each do |item|
        team= Team.find_by(id: item['TeamID'])
        unless team.locked
          team.ap_rank = item['ApRank']
          team.wins = item['Wins']
          team.losses = item['Losses']
          team.conference_wins = item['ConferenceWins']
          team.conference_losses = item['ConferenceLosses']
          team.save
        end
      end
    end
    
    # Get players
    url = URI.parse('https://api.fantasydata.net/api/cbb/fantasy/json/Players?key=' + api_key)
    puts 'Getting players'
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
      http.request(req)
    end
    json_res =  res.body
    obj = JSON.parse(json_res)
    obj.each do |item|
      player = Player.find_or_create_by(id: item['PlayerID'])
      unless player.locked
        player.first_name = item['FirstName']
        player.last_name = item['LastName']
        player.jersey = item['Jersey']
        player.position = item['Position']
        player.year = item['Class']
        player.height = item['Height']
        player.weight = item['Weight']
        player.team_id = item['TeamID']
        player.active = true
        player.save
      end
    end
    
    # Get team seasons
    url = URI.parse('https://api.fantasydata.net/api/cbb/odds/json/TeamSeasonStats/' + current_year + '?key='+ api_key)
    puts 'Getting team seasons'
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
      http.request(req)
    end
    json_res =  res.body
    obj = JSON.parse(json_res)
    obj.each do |item|
      team_season = TeamSeason.find_or_create_by(team_id: item['TeamID'], year: current_year)
      unless team_season.locked
        team_season.id = item['StatID']
        team_season.team_id = item['TeamID']
        team_season.season_id = Season.find_by(season: item['Season']).id
        team_season.year = item['Season']
        team_season.season_type = item['SeasonType']
        team_season.name = item['Name']
        team_season.team_abbreviation = item['Team']
        team_season.wins = item['Wins']
        team_season.losses = item['Losses']
        team_season.conference_wins = item['ConferenceWins']
        team_season.conference_losses = item['ConferenceLosses']
        team_season.games = item['Games']
        team_season.minutes = item['Minutes']
        team_season.field_goals_made = item['FieldGoalsMade']
        team_season.field_goals_attempted = item['FieldGoalsAttempted']
        team_season.field_goals_percentage = item['FieldGoalsPercentage']
        team_season.two_pointers_made = item['TwoPointersMade']
        team_season.two_pointers_attempted = item['TwoPointersAttempted']
        team_season.two_pointers_percentage = item['TwoPointersPercentage']
        team_season.three_pointers_made = item['ThreePointersMade']
        team_season.three_pointers_attempted = item['ThreePointersAttempted']
        team_season.three_pointers_percentage = item['ThreePointersPercentage']
        team_season.free_throws_made = item['FreeThrowsMade']
        team_season.free_throws_attempted = item['FreeThrowsAttempted']
        team_season.free_throws_percentage = item['FreeThrowsPercentage']
        team_season.offensive_rebounds = item['OffensiveRebounds']
        team_season.defensive_rebounds = item['DefensiveRebounds']
        team_season.rebounds = item['Rebounds']
        team_season.offensive_rebounds_percentage = item['OffensiveReboundsPercentage']
        team_season.defensive_rebounds_percentage = item['DefensiveReboundsPercentage']
        team_season.total_rebounds_percentage = item['TotalReboundsPercentage']
        team_season.assists = item['Assists']
        team_season.steals = item['Steals']
        team_season.blocked_shots = item['BlockedShots']
        team_season.turnovers = item['Turnovers']
        team_season.personal_fouls = item['PersonalFouls']
        team_season.points = item['Points']
        team_season.save
      end
    end
    
    # Get player seasons
    url = URI.parse('https://api.fantasydata.net/api/cbb/fantasy/json/PlayerSeasonStats/' + current_year.to_s + '?key='+ api_key)
    puts 'Getting player seasons'
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
      http.request(req)
    end
    json_res =  res.body
    obj = JSON.parse(json_res)
    obj.each do |item|
      player_season = PlayerSeason.find_or_create_by(id: item['StatID'])
      unless player_season.locked
        player_season.team = Team.find_by(id: item['TeamID'])
        player = Player.find_or_create_by(id: item['PlayerID'])
        if player.last_name.nil?
          player.last_name = item['Name'].split[1..-1].join(' ')
          player.first_name = item['Name'].split.first
          player.position = item['Position']
          player.active = false
          player.team = player_season.team
          if !player.save
            player = nil
          end
        end
        player_season.player = player
        player_season.team_season = TeamSeason.find_by(year: item['Season'], team_id: item['TeamID'])
        player_season.season_id = Season.find_by(season: item['Season']).id
        player_season.year = item['Season']
        player_season.season_type = item['SeasonType']
        player_season.name = item['Name']
        player_season.position = item['Position']
        player_season.team_name = item['Team']
        player_season.updated = item['Updated']
        player_season.games = item['Games']
        player_season.minutes = item['Minutes']
        player_season.field_goals_made = item['FieldGoalsMade']
        player_season.field_goals_attempted = item['FieldGoalsAttempted']
        player_season.field_goals_percentage = item['FieldGoalsPercentage']
        player_season.effective_field_goals_percentage = item['EffectiveFieldGoalsPercentage']
        player_season.two_pointers_made = item['TwoPointersMade']
        player_season.two_pointers_attempted = item['TwoPointersAttempted']
        player_season.two_pointers_percentage = item['TwoPointersPercentage']
        player_season.three_pointers_made = item['ThreePointersMade']
        player_season.three_pointers_attempted = item['ThreePointersAttempted']
        player_season.three_pointers_percentage = item['ThreePointersPercentage']
        player_season.free_throws_made = item['FreeThrowsMade']
        player_season.free_throws_attempted = item['FreeThrowsAttempted']
        player_season.free_throws_percentage = item['FreeThrowsPercentage']
        player_season.offensive_rebounds = item['OffensiveRebounds']
        player_season.defensive_rebounds = item['DefensiveRebounds']
        player_season.rebounds = item['Rebounds']
        player_season.offensive_rebounds_percentage = item['OffensiveReboundsPercentage']
        player_season.defensive_rebounds_percentage = item['DefensiveReboundsPercentage']
        player_season.total_rebounds_percentage = item['TotalReboundsPercentage']
        player_season.assists = item['Assists']
        player_season.steals = item['Steals']
        player_season.blocked_shots = item['BlockedShots']
        player_season.turnovers = item['Turnovers']
        player_season.personal_fouls = item['PersonalFouls']
        player_season.points = item['Points']
        player_season.true_shooting_percentage = item['TrueShootingPercentage']
        player_season.player_efficiency_rating = item['PlayerEfficiencyRating']
        player_season.assists_percentage = item['AssistsPercentage']
        player_season.steals_percentage = item['StealsPercentage']
        player_season.blocks_percentage = item['BlocksPercentage']
        player_season.turnovers_percentage = item['TurnOversPercentage']
        player_season.usage_rate = item['UsageRatePercentage']
        player_season.save
      end
    end
    
    # Get games
    season = Season.find_by(season: current_year)
    start_date = Date.today
    puts "Getting all games"
    ((start_date - 4.days)..season.post_season_end_date).each do |date|
      str_date = date.strftime('%Y-%^b-%d')
      url = URI.parse('https://api.fantasydata.net/api/cbb/odds/json/GamesByDate/' + str_date + '?key='+ api_key)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
        http.request(req)
      end
      json_res =  res.body
      obj = JSON.parse(json_res)
      obj.each do |item|
        game = Game.find_or_create_by(id: item['GameID'])
        unless game.locked
          game.year = item['Season']
          game.season_type = item['SeasonType']
          game.status = item['Status']
          game.day = item['Day']
          game.date_time = item['DateTime']
          game.away_team_name = item['AwayTeam']
          game.home_team_name = item['HomeTeam']
          game.away_team_score = item['AwayTeamScore']
          game.home_team_score = item['HomeTeamScore']
          game.point_spread = item['PointSpread']
          game.over_under = item['OverUnder']
          game.away_team_money_line = item['AwayTeamMoneyLine']
          game.home_team_money_line = item['HomeTeamMoneyLine']
          unless item['Stadium'].nil?
            stadium = Stadium.find_by(id: item['Stadium']['StadiumID']) 
          else 
            stadium = Stadium.last
          end
          away_team = Team.find_by(id: item['AwayTeamID'])
          home_team = Team.find_by(id: item['HomeTeamID'])
          game.season = Season.find_by(season: item['Season'])
          game.stadium = stadium
          game.away_team = away_team
          game.home_team = home_team
          thrill_score = 0
          if game.home_team && game.away_team
            home_team_season = TeamSeason.find_by(team: game.home_team, season: season)
            away_team_season = TeamSeason.find_by(team: game.away_team, season: season)
            thrill_score += 1002.0
            if home_team_season && away_team_season
              thrill_score += -home_team_season.adjem_rank
              thrill_score += -away_team_season.adjem_rank
            else
              thrill_score = 350.0
            end
            if game.prediction
              thrill_score += -(game.prediction.predicted_point_spread ** 1.80)
            end
          end
          game.thrill_score = (thrill_score / 1000.0).round(3)
          begin
            game.save
          rescue Exception => e
            puts e.full_message
          end
        end
      end
    end
    
    # Get team games
    start_date = Date.today
    ((start_date - 4.days)..start_date).each do |date|
      str_date = date.strftime('%Y-%^b-%d')
      url = URI.parse('https://api.fantasydata.net/api/cbb/odds/json/TeamGameStatsByDate/' + str_date + '?key='+ api_key)
      puts "Dowloading " + str_date + ' team games'
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
        http.request(req)
      end
      json_res =  res.body
      obj = JSON.parse(json_res)
      obj.each do |item|
        game = TeamGame.find_or_create_by(id: item['StatID'])
        unless game.locked
          game.year = item['Season']
          game.season_type = item['SeasonType']
          game.team_abbreviation = item['Team']
          game.team_name = item['Name']
          game.wins = item['Wins']
          game.losses = item['Losses']
          game.opponent_name = item['Opponent']
          game.day = item['Day']
          game.date_time = item['DateTime']
          game.home_or_away = item['HomeOrAway']
          game.num_games = item['Games']
          game.minutes = item['Minutes']
          game.field_goals_made = item['FieldGoalsMade']
          game.field_goals_attempted = item['FieldGoalsAttempted']
          game.field_goals_percentage = item['FieldGoalsPercentage']
          game.two_pointers_made = item['TwoPointersMade']
          game.two_pointers_attempted = item['TwoPointersAttempted']
          game.two_pointers_percentage = item['TwoPointersPercentage']
          game.three_pointers_made = item['ThreePointersMade']
          game.three_pointers_attempted = item['ThreePointersAttempted']
          game.three_pointers_percentage = item['ThreePointersPercentage']
          game.free_throws_made = item['FreeThrowsMade']
          game.free_throws_attempted = item['FreeThrowsAttempted']
          game.free_throws_percentage = item['FreeThrowsPercentage']
          game.offensive_rebounds = item['OffensiveRebounds']
          game.defensive_rebounds = item['DefensiveRebounds']
          game.rebounds = item['Rebounds']
          game.assists = item['Assists']
          game.steals = item['Steals']
          game.blocked_shots = item['BlockedShots']
          game.turnovers = item['Turnovers']
          game.personal_fouls = item['PersonalFouls']
          game.points = item['Points']
          game.team = Team.find_by(id: item['TeamID'])
          game.opponent = Team.find_by(id: item['OpponentID'])
          game.game_id = item['GameID']
          game.season = Season.find_by(season: item['Season'])
          game.save
        end
      end
    end
    
    # Getting player games
    start_date = Date.today
    ((start_date - 4.days)..start_date).each do |date|
      str_date = date.strftime('%Y-%^b-%d')
      url = URI.parse('https://api.fantasydata.net/api/cbb/fantasy/json/PlayerGameStatsByDate/' + str_date + '?key='+ api_key)
      puts "Dowloading " + str_date + ' player games'
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
        http.request(req)
      end
      json_res =  res.body
      obj = JSON.parse(json_res)
      obj.each do |item|
        game = PlayerGame.find_or_create_by(id: item['StatID'])
        game.year = item['Season']
        game.season_type = item['SeasonType']
        game.name = item['Name']
        game.team_name = item['Team']
        game.position = item['Position']
        game.injury_status = item['InjuryStatus']
        game.opponent_name = item['Opponent']
        game.day = item['Day']
        game.date_time = item['DateTime']
        game.home_or_away = item['HomeOrAway']
        game.num_games = item['Games']
        game.minutes = item['Minutes']
        game.field_goals_made = item['FieldGoalsMade']
        game.field_goals_attempted = item['FieldGoalsAttempted']
        game.field_goals_percentage = item['FieldGoalsPercentage']
        game.two_pointers_made = item['TwoPointersMade']
        game.two_pointers_attempted = item['TwoPointersAttempted']
        game.two_pointers_percentage = item['TwoPointersPercentage']
        game.three_pointers_made = item['ThreePointersMade']
        game.three_pointers_attempted = item['ThreePointersAttempted']
        game.three_pointers_percentage = item['ThreePointersPercentage']
        game.free_throws_made = item['FreeThrowsMade']
        game.free_throws_attempted = item['FreeThrowsAttempted']
        game.free_throws_percentage = item['FreeThrowsPercentage']
        game.offensive_rebounds = item['OffensiveRebounds']
        game.defensive_rebounds = item['DefensiveRebounds']
        game.rebounds = item['Rebounds']
        game.assists = item['Assists']
        game.steals = item['Steals']
        game.blocked_shots = item['BlockedShots']
        game.turnovers = item['Turnovers']
        game.personal_fouls = item['PersonalFouls']
        game.points = item['Points']
        game.player = Player.find_by(id: item['PlayerID'])
        game.team = Team.find_by(id: item['TeamID'])
        game.opponent = Team.find_by(id: item['OpponentID'])
        game.game_id = item['GameID']
        game.season = Season.find_by(season: item['Season'])
        game.player_season = PlayerSeason.find_by(player: game.player, season: game.season)
        game.save
      end
    end
  end
  
  task calcs: :environment do
    # Game Stats Calcs
    puts 'Calculating game stats'
    current_season = Season.find_by(season: current_year)
    games = Game.where(season: current_season).where("day < ?", Date.today + 1.day)
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
          rescue Exception => e
            puts e.full_message
          end
        end
      end
    end
    
    # Season stats calcs
    puts 'Calculating season stats'
    current_season = Season.find_by(season: current_year)
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
      if season_games_total > 0
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
      end
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
      if season.assists_percentage && season.assists_percentage_allowed
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
    
  ########## RATING CALC ###########################################
  ########## LONG SECTION #########################################
  
    current_season = Season.find_by(season: current_year)
    team_seasons = TeamSeason.where(season: current_season)
    error_count = 0
    oeff_error = 0
    error_fraction = 1
    x = 0
    while error_fraction > 0.05 && x < 6
      old_oerror = oeff_error
      oeff_error = 0
      team_seasons.each do |season|
        team_games = TeamGame.where(team: season.team, season: current_season).order(day: :asc)
        unless team_games.count == 0
          adj_ortg_error = 0
          adj_drtg_error = 0
          adj_tempo_error = 0
          divisor = 0.1
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
          if game_count < 15
            season.adj_offensive_efficiency = (((game_count * ((season.adj_offensive_efficiency + (adj_ortg_error / divisor)))) + (4 * season.initial_adj_o)) / (4 + game_count)).round(1)
            season.adj_defensive_efficiency = (((game_count * ((season.adj_defensive_efficiency + (adj_drtg_error / divisor)))) + (4 * season.initial_adj_d)) / (4 + game_count)).round(1)
            season.adj_tempo = ((( game_count * ((season.adj_tempo + (adj_tempo_error / divisor)))) + (4 * season.initial_adj_t)) / (4 + game_count)).round(1)
          else
            season.adj_offensive_efficiency = (season.adj_offensive_efficiency + (adj_ortg_error / divisor)).round(1)
            season.adj_defensive_efficiency = (season.adj_defensive_efficiency + (adj_drtg_error / divisor)).round(1)
            season.adj_tempo = (season.adj_tempo + (adj_tempo_error / divisor)).round(1)
          end
          season.adj_efficiency_margin = ((season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (current_season.adj_defensive_efficiency - season.adj_defensive_efficiency)).round(1)
          season.save
          oeff_error += (adj_ortg_error ** 2).round(1)
        end
      end
      team_seasons.reload
      current_season.adj_offensive_efficiency = team_seasons.average(:adj_offensive_efficiency)
      current_season.adj_defensive_efficiency = team_seasons.average(:adj_defensive_efficiency)
      current_season.adj_tempo = team_seasons.average(:adj_tempo)
      current_season.save
      current_season.reload
      error_fraction = Math.sqrt(((oeff_error - old_oerror) / oeff_error) ** 2.0) 
      x += 1
    end
    puts "Calculating game by game advantages"
    team_seasons.each do |season|
      games_array = []
      season.adjem_rank = TeamSeason.where(season: current_season).order(adj_efficiency_margin: :desc).pluck(:id).index(season.id) + 1
  
    #   #### Game by Game advantage calculations ####
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
            game.assists_percentage = 100.0 if game.assists_percentage > 100.0
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
      if season.games && season.games > 10
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
    if current_season.consistency.to_f.nan?
      current_season.consistency = 14.0
    end
    current_season.save
    end
  
    TeamSeason.where(year: current_year).each do |season|
      season.adjem_rank = TeamSeason.where(year: current_year).order(adj_efficiency_margin: :desc).pluck(:id).index(season.id) + 1
      season.save
    end
  ########### PLAYER STATS CALC######################################
  ########### LONG SECTION #########################################
    puts "Starting player advanced stats"
    current_season = Season.find_by(season: current_year)
    player_games = PlayerGame.where(season: current_season).where("day > ?", Date.today - 5.days)
    count = player_games.count
    x = 0
    player_games.each do |game|
      team_game = game.game.team_games.find_by(team: game.team)
      opponent_game = game.game.team_games.find_by(team: team_game.opponent) if !team_game.nil?
      if team_game && opponent_game
        team_season = TeamSeason.find_by(team: team_game.team, season: current_season)
        opponent_season = TeamSeason.find_by(team: opponent_game.team, season: current_season)
        if team_season && opponent_season
          if game.minutes > 0 && team_game.minutes > 0
              game.assists_percentage = ((100.0 * game.assists.to_f) / (((game.minutes / (team_game.minutes / 5.0)) * team_game.field_goals_made) - game.field_goals_made.to_f)).round(1)
              game.assists_percentage = 0.0 if game.assists_percentage.to_f.nan?
              game.assists_percentage = 100.0 if game.assists_percentage > 100.0
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
          end
        end
      end
      x += 1
      if x % 1000 == 0
        puts x.to_s + " of " + count.to_s + " games completed."
      end
    end
    player_seasons = PlayerSeason.where(season: current_season)
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
    
    ####### PREDICTIONS CALCULATIONS #########################
    puts "Beginning predictions"
    current_season = Season.find_by(season: current_year)
    season_games = Game.where(season: current_season).where("day > ?", Date.today - 1.day)
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
        predicted_pace = (home_team_season.adj_tempo - current_season.adj_tempo) + (away_team_season.adj_tempo - current_season.adj_tempo) + current_season.adj_tempo
        # Matchup Specific Modifiers
        if game.home_team.stadium == game.stadium
          if home_team_season.home_advantage && away_team_season.home_advantage
            home_advantage = (((4.0 * current_season.home_advantage) + home_team_season.home_advantage + away_team_season.home_advantage)/ 6.0).round(1)
            predicted_home_efficiency += home_advantage / 2.0
            predicted_away_efficiency += home_advantage / -2.0
          else
            home_advantage = 2.5
            predicted_home_efficiency += 1.75
            predicted_away_efficiency += -1.75
          end
        end
        if home_team_season.defensive_style_advantage && away_team_season.defensive_style_advantage
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
        end
        
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
          ##### MONEYLINE CALCS ######
          mean = predicted_home_efficiency - predicted_away_efficiency
          std_dev = Math.sqrt(2 * current_season.consistency ** 2) 
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
          ############## RECOMMENDED BETS ###########################
          if prediction.point_spread && prediction.predicted_point_spread
            prediction.prediction_difference_point_spread = prediction.predicted_point_spread - prediction.point_spread
            predicted_home_efficiency_diff = prediction.point_spread * (100.0 / predicted_pace)
            if prediction.prediction_difference_point_spread < 0.5
              home_cover_z_score = -(mean + predicted_home_efficiency_diff) / std_dev
              prediction.confidence_point_spread = getProbability(home_cover_z_score).round(5)
              prediction.expected_value_point_spread = ((90.9 * prediction.confidence_point_spread) - (100.0 * (1- prediction.confidence_point_spread))).round(5)
              prediction.home_favorite = true
              if prediction.point_spread < 0
                prediction.favorite_favorite = true
              elsif prediction.point_spread > 0
                prediction.favorite_favorite = false
              end
              if home_team_season.adj_tempo > away_team_season.adj_tempo
                prediction.pace_favorite = true
              elsif home_team_season.adj_tempo < away_team_season.adj_tempo
                prediction.pace_favorite = false
              end
            elsif prediction.prediction_difference_point_spread > 0.5
              away_cover_z_score = (predicted_home_efficiency_diff + mean) / std_dev
              prediction.confidence_point_spread = getProbability(away_cover_z_score).round(5)
              prediction.expected_value_point_spread = ((90.9 * prediction.confidence_point_spread) - (100.0 * (1- prediction.confidence_point_spread))).round(5)
              prediction.home_favorite = false
              if prediction.point_spread < 0
                prediction.favorite_favorite = false
              elsif prediction.point_spread > 0
                prediction.favorite_favorite = true
              end
              if home_team_season.adj_tempo > away_team_season.adj_tempo
                prediction.pace_favorite = false
              elsif home_team_season.adj_tempo < away_team_season.adj_tempo
                prediction.pace_favorite = true
              end
            end
            if prediction.moneyline
              if prediction.moneyline < 0 
                away_probability = 1.0 - (prediction.moneyline / (prediction.moneyline - 100.0)) + 0.1
                away_moneyline = ((1.0 - away_probability) / away_probability) * 100.0
                home_win_value = ((prediction.home_win_probability / 100.0) * (100.0 / (prediction.moneyline / -100.0))) - (100.0 * (1 - (prediction.home_win_probability / 100.0)))
                away_win_value = ((1.0 - (prediction.home_win_probability / 100.0)) * away_moneyline) - (prediction.home_win_probability)
              else
                away_probability = 1.0 - (100.0 / (prediction.moneyline + 100.0)) + 0.1
                away_moneyline = (away_probability / (1.0 - away_probability)) * -100
                home_win_value = (((prediction.home_win_probability / 100.0) * 100.0 * (prediction.moneyline / 100.0))) - (100.0 * (1 - (prediction.home_win_probability / 100.0)))
                away_win_value = ((1.0 - (prediction.home_win_probability / 100.0)) * (100.0 / (away_moneyline / -100.0))) - (prediction.home_win_probability)
              end
              if home_win_value > 0
                prediction.expected_value_moneyline = home_win_value
                prediction.confidence_moneyline = (prediction.home_win_probability / 100.0)
                prediction.home_moneyline_bet = 'HOME'
              elsif away_win_value > 0
                prediction.expected_value_moneyline = away_win_value
                prediction.confidence_moneyline = (1.0 - (prediction.home_win_probability / 100.0)).round(4)
                prediction.home_moneyline_bet = 'AWAY'
              end
            end
            if prediction.over_under && prediction.predicted_over_under
              pace_standard_dev = (predicted_tempo / 69.0) * 14.06
              if prediction.predicted_over_under > prediction.over_under
                over_z_score = (prediction.over_under - prediction.predicted_over_under) / pace_standard_dev
                prediction.confidence_over_under = getProbability(over_z_score).round(5)
              elsif prediction.predicted_over_under < prediction.over_under
                under_z_score = (prediction.predicted_over_under - prediction.over_under) / pace_standard_dev
                prediction.confidence_over_under = getProbability(under_z_score).round(5)
              end
              prediction.expected_value_over_under = (prediction.confidence_over_under * 90.0) - (100.0 * ( 1 - prediction.confidence_over_under)) if prediction.confidence_over_under
            end
          end
          
          
          
          
          ############# PREDICTION DESCRIPTION ############################
          prediction.description = "Please stay tuned for detailed descriptions. Matchup specific modifiers will not be applied until each team has played at least 10 games in the season."
          prediction.save
        rescue StandardError => e
          puts e.full_message
        end
      end
    end
    puts "Begin inspecting prediction outcomes"
    season_games = Game.where(season: current_season).where("day < ? " ,  Date.today + 1.day)
    x = 0
    season_games.each do |game|
      x += 1
      home_team_season = TeamSeason.find_by(season: current_season, team: game.home_team)
      away_team_season = TeamSeason.find_by(season: current_season, team: game.away_team)
      if home_team_season && away_team_season
        prediction = Prediction.find_or_create_by(game: game)
        prediction.point_spread = game.point_spread
        prediction.over_under = game.over_under
        prediction.moneyline = game.home_team_money_line
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
          else
          end
        
          if game.home_team_score && game.away_team_score && prediction.over_under && prediction.predicted_over_under
            ### OVER/UNDER OUTCOME ###
            if prediction.predicted_over_under > (prediction.over_under + 1)
              # over bet
              if (game.away_team_score + game.home_team_score) > prediction.over_under
                # winning bet
                prediction.win_over_under = true
                prediction.winnings_over_under = 90.9
              elsif (game.away_team_score + game.home_team_score) < prediction.over_under
                # losing bet
                prediction.win_over_under = false
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
  
  task predictions: :environment do
    puts "Beginning predictions"
    current_season = Season.find_by(season: current_year)
    season_games = Game.where(season: current_season).where("day > ?", Date.today - 1.day)
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
        predicted_pace = (home_team_season.adj_tempo - current_season.adj_tempo) + (away_team_season.adj_tempo - current_season.adj_tempo) + current_season.adj_tempo
        # Matchup Specific Modifiers
        if game.home_team.stadium == game.stadium
          if home_team_season.home_advantage && away_team_season.home_advantage
            home_advantage = (((4.0 * current_season.home_advantage) + home_team_season.home_advantage + away_team_season.home_advantage)/ 6.0).round(1)
            predicted_home_efficiency += home_advantage / 2.0
            predicted_away_efficiency += home_advantage / -2.0
          else
            home_advantage = 2.5
            predicted_home_efficiency += 1.75
            predicted_away_efficiency += -1.75
          end
        end
        if home_team_season.defensive_style_advantage && away_team_season.defensive_style_advantage
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
        end
        
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
          ##### MONEYLINE CALCS ######
          mean = predicted_home_efficiency - predicted_away_efficiency
          std_dev = Math.sqrt(2 * current_season.consistency ** 2) 
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
          ############## RECOMMENDED BETS ###########################
          if prediction.point_spread && prediction.predicted_point_spread
            prediction.prediction_difference_point_spread = prediction.predicted_point_spread - prediction.point_spread
            predicted_home_efficiency_diff = prediction.point_spread * (100.0 / predicted_pace)
            if prediction.prediction_difference_point_spread < 0.5
              home_cover_z_score = -(mean + predicted_home_efficiency_diff) / std_dev
              prediction.confidence_point_spread = getProbability(home_cover_z_score).round(5)
              prediction.expected_value_point_spread = ((90.9 * prediction.confidence_point_spread) - (100.0 * (1- prediction.confidence_point_spread))).round(5)
              prediction.home_favorite = true
              if prediction.point_spread < 0
                prediction.favorite_favorite = true
              elsif prediction.point_spread > 0
                prediction.favorite_favorite = false
              end
              if home_team_season.adj_tempo > away_team_season.adj_tempo
                prediction.pace_favorite = true
              elsif home_team_season.adj_tempo < away_team_season.adj_tempo
                prediction.pace_favorite = false
              end
            elsif prediction.prediction_difference_point_spread > 0.5
              away_cover_z_score = (predicted_home_efficiency_diff + mean) / std_dev
              prediction.confidence_point_spread = getProbability(away_cover_z_score).round(5)
              prediction.expected_value_point_spread = ((90.9 * prediction.confidence_point_spread) - (100.0 * (1- prediction.confidence_point_spread))).round(5)
              prediction.home_favorite = false
              if prediction.point_spread < 0
                prediction.favorite_favorite = false
              elsif prediction.point_spread > 0
                prediction.favorite_favorite = true
              end
              if home_team_season.adj_tempo > away_team_season.adj_tempo
                prediction.pace_favorite = false
              elsif home_team_season.adj_tempo < away_team_season.adj_tempo
                prediction.pace_favorite = true
              end
            end
            if prediction.moneyline
              if prediction.moneyline < 0 
                away_probability = 1.0 - (prediction.moneyline / (prediction.moneyline - 100.0)) + 0.1
                away_moneyline = ((1.0 - away_probability) / away_probability) * 100.0
                home_win_value = ((prediction.home_win_probability / 100.0) * (100.0 / (prediction.moneyline / -100.0))) - (100.0 * (1 - (prediction.home_win_probability / 100.0)))
                away_win_value = ((1.0 - (prediction.home_win_probability / 100.0)) * away_moneyline) - (prediction.home_win_probability)
              else
                away_probability = 1.0 - (100.0 / (prediction.moneyline + 100.0)) + 0.1
                away_moneyline = (away_probability / (1.0 - away_probability)) * -100
                home_win_value = (((prediction.home_win_probability / 100.0) * 100.0 * (prediction.moneyline / 100.0))) - (100.0 * (1 - (prediction.home_win_probability / 100.0)))
                away_win_value = ((1.0 - (prediction.home_win_probability / 100.0)) * (100.0 / (away_moneyline / -100.0))) - (prediction.home_win_probability)
              end
              if home_win_value > 0
                prediction.expected_value_moneyline = home_win_value
                prediction.confidence_moneyline = (prediction.home_win_probability / 100.0)
                prediction.home_moneyline_bet = 'HOME'
              elsif away_win_value > 0
                prediction.expected_value_moneyline = away_win_value
                prediction.confidence_moneyline = (1.0 - (prediction.home_win_probability / 100.0)).round(4)
                prediction.home_moneyline_bet = 'AWAY'
              end
            end
            if prediction.over_under && prediction.predicted_over_under
              pace_standard_dev = (predicted_tempo / 69.0) * 14.06
              if prediction.predicted_over_under > prediction.over_under
                over_z_score = (prediction.over_under - prediction.predicted_over_under) / pace_standard_dev
                prediction.confidence_over_under = getProbability(over_z_score).round(5)
              elsif prediction.predicted_over_under < prediction.over_under
                under_z_score = (prediction.predicted_over_under - prediction.over_under) / pace_standard_dev
                prediction.confidence_over_under = getProbability(under_z_score).round(5)
              end
              prediction.expected_value_over_under = (prediction.confidence_over_under * 90.0) - (100.0 * ( 1 - prediction.confidence_over_under)) if prediction.confidence_over_under
            end
          end
          
          
          
          
          ############# PREDICTION DESCRIPTION ############################
          prediction.description = "Please stay tuned for detailed descriptions. Matchup specific modifiers will not be applied until each team has played at least 10 games in the season."
          prediction.save
        rescue StandardError => e
          puts e.full_message
        end
      end
    end
    puts "Begin inspecting prediction outcomes"
    season_games = Game.where(season: current_season).where("day < ? " ,  Date.today + 1.day)
    x = 0
    season_games.each do |game|
      x += 1
      home_team_season = TeamSeason.find_by(season: current_season, team: game.home_team)
      away_team_season = TeamSeason.find_by(season: current_season, team: game.away_team)
      if home_team_season && away_team_season
        prediction = Prediction.find_or_create_by(game: game)
        prediction.point_spread = game.point_spread
        prediction.over_under = game.over_under
        prediction.moneyline = game.home_team_money_line
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
          else
          end
        
          if game.home_team_score && game.away_team_score && prediction.over_under && prediction.predicted_over_under
            ### OVER/UNDER OUTCOME ###
            if prediction.predicted_over_under > (prediction.over_under + 1)
              # over bet
              if (game.away_team_score + game.home_team_score) > prediction.over_under
                # winning bet
                prediction.win_over_under = true
                prediction.winnings_over_under = 90.9
              elsif (game.away_team_score + game.home_team_score) < prediction.over_under
                # losing bet
                prediction.win_over_under = false
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
end
