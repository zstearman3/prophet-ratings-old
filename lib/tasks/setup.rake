require 'net/http'

namespace :setup do
  desc "Download league hierarchy from fantasydata.com"
  task hierarchy: :environment do
    api_key = 'ead8f64bde6e4b6cab0bbbf95c6d98db'
    url = URI.parse('https://api.sportsdata.io/v3/cbb/scores/json/LeagueHierarchy?key=' + api_key)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body
  end

end
