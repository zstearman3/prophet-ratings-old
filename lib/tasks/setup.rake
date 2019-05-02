require 'net/http'

namespace :setup do
  desc "Download league hierarchy from fantasydata.com"
  task hierarchy: :environment do
    api_key = 'ead8f64bde6e4b6cab0bbbf95c6d98db'
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

end
