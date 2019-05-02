require 'net/http'

namespace :setup do
  desc "Download database info from fantasydata.com"
  api_key = 'ead8f64bde6e4b6cab0bbbf95c6d98db'
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

end
