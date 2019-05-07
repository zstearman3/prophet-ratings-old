require 'net/http'

namespace :setup do
  desc "Download database info from fantasydata.com"
  api_key = 'ead8f64bde6e4b6cab0bbbf95c6d98db'
  sd_api_key = '8b5aef100e21492e869155a34e58e245'
  task hierarchy: :environment do
    url = URI.parse('https://api.fantasydata.net/api/cbb/fantasy/json/LeagueHierarchy?key=' + api_key)
    puts url
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
      http.request(req)
    end
    json_res =  res.body
    
    # Parse data and import conferences, teams, and stadiums
    obj = JSON.parse(json_res)
    obj.each do |conf|
      conference = Conference.find_or_create_by(id: conf['ConferenceID'])
      conference.name = conf['Name']
      conference.save
      conf['Teams'].each do |item|
        team = Team.find_or_create_by(id: item['TeamID'])
        team.school = item['School']
        team.name = item['Name']
        team.ap_rank = item['ApRank']
        team.wins = item['Wins']
        team.losses = item['Losses']
        team.conference_wins = item['ConferenceWins']
        team.conference_losses = item['ConferenceLosses']
        team.short_display_name = item['ShortDisplayName']
        stadium = Stadium.find_or_create_by(id: item['Stadium']['StadiumID'])
        stadium.name = item['Stadium']['Name']
        stadium.city = item['Stadium']['City']
        stadium.state = item['Stadium']['State']
        stadium.country = item['Stadium']['Country']
        stadium.capacity = item['Stadium']['Capacity']
        stadium.save
        team.conference = conference
        team.stadium = stadium
        team.save
      end
    end
  end
  
  task get_players: :environment do
    url = URI.parse('https://api.fantasydata.net/api/cbb/fantasy/json/Players?key=' + api_key)
    puts url
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
      http.request(req)
    end
    json_res =  res.body
    
    # Parse data and import conferences, teams, and stadiums
    obj = JSON.parse(json_res)
    obj.each do |item|
      player = Player.find_or_create_by(id: item['PlayerID'])
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
  
  task team_seasons: :environment do
    url = URI.parse('https://api.sportsdata.io/v3/cbb/scores/json/TeamSeasonStats/2019?key='+ sd_api_key)
    puts url
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme = 'https') do |http|
      http.request(req)
    end
    json_res =  res.body
    obj = JSON.parse(json_res)
    obj.each do |item|
      team_season = TeamSeason.find_or_create_by(id: item['StatID'])
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
      team_season.possessions = item['Possessions']
      team_season.updated = item['Updated']
      team_season.games = item['Games']
      team_season.minutes = item['Minutes']
      team_season.field_goals_made = item['FieldGoalsMade']
      team_season.field_goals_attempted = item['FieldGoalsAttempted']
      team_season.field_goals_percentage = item['FieldGoalsPercentage']
      team_season.effective_field_goals_percentage = item['EffectiveFieldGoalsPercentage']
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
      team_season.assists = item['assists']
      team_season.steals = item['steals']
      team_season.blocked_shots = item['blocked_shots']
      team_season.turnovers = item['turnovers']
      team_season.personal_fouls = item['personal_fouls']
      team_season.points = item['points']
      team_season.true_shooting_percentage = item['TrueShootingPercentage']
      team_season.assists_percentage = item['AssistsPercentage']
      team_season.steals_percentage = item['StealsPercentage']
      team_season.blocks_percentage = item['BlocksPercentage']
      team_season.turnovers_percentage = item['TurnoversPercentage']
      team_season.save
    end
  end

end
