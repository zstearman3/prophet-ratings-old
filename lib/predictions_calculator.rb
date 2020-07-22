module PredictionsCalculator
    def home_advantage_calc(current_season, game, home_team_season, away_team_season)
      season_home_advantage = 3.0
      season_home_advantage = current_season.home_advantage unless current_season.home_advantage.nan?
      begin
        home_advantage = (((4.0 * season_home_advantage) + home_team_season.home_advantage + away_team_season.home_advantage)/ 6.0).round(1)
      rescue
        home_advantage = 3.0
      end
      return home_advantage
    end
    
end