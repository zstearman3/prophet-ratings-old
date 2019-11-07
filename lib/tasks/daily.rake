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
          begin
            game.save
          rescue Exception => e
            puts e.full_messages
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
end
