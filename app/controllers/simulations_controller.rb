class SimulationsController < ApplicationController
  include Gaussian
  before_action :logged_in_user
  
  def new_simulation
    @team_seasons = TeamSeason.where(season: current_season).order(name: :asc)
  end
  
  def simulation_result
    @home_team_season = TeamSeason.find(params[:home_team][:id])
    @away_team_season = TeamSeason.find(params[:away_team][:id])
    @home_team = @home_team_season.team
    @away_team = @away_team_season.team
    if @home_team_season && @away_team_season
      home_advantage = 0.0
      defensive_advantage = 0.0
      assists_advantage = 0.0
      three_pointers_advantage = 0.0
      pace_advantage = 0.0
      @prediction = Prediction.new
      predicted_tempo = (@home_team_season.adj_tempo - current_season.adj_tempo) + (@away_team_season.adj_tempo - current_season.adj_tempo) + current_season.adj_tempo
      predicted_home_efficiency = (@home_team_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (@away_team_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency
      predicted_away_efficiency = (@away_team_season.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (@home_team_season.adj_defensive_efficiency - current_season.adj_defensive_efficiency) + current_season.adj_offensive_efficiency        
      # Matchup Specific Modifiers
      unless params[:neutral] == '1'
        if @home_team_season.home_advantage && @away_team_season.home_advantage
          home_advantage = (((4.0 * current_season.home_advantage) + @home_team_season.home_advantage + @away_team_season.home_advantage)/ 6.0).round(1)
          predicted_home_efficiency += home_advantage / 2.0
          predicted_away_efficiency += home_advantage / -2.0
        else
          home_advantage = 2.5
          predicted_home_efficiency += 1.75
          predicted_away_efficiency += -1.75
        end
      end
      if @home_team_season.defensive_style_advantage && @away_team_season.defensive_style_advantage
        if @home_team_season.r_defensive_style > 0.1
          defensive_advantage += @home_team_season.defensive_style_advantage * (@home_team_season.r_defensive_style / 0.15) * (@away_team_season.defensive_aggression / 10.0)
        end
        
        if @away_team_season.r_defensive_style > 0.1
          defensive_advantage += -@away_team_season.defensive_style_advantage * (@away_team_season.r_defensive_style / 0.15) * (@home_team_season.defensive_aggression / 10.0)
        end
        
        if @home_team_season.r_assists > 0.1
          assists_advantage += @home_team_season.assists_advantage * (@home_team_season.r_assists / 0.15) * ((@away_team_season.assists_percentage - current_season.assists_percentage) / 1.5)
        end
        
        if @away_team_season.r_assists > 0.1
          assists_advantage += -@away_team_season.assists_advantage * (@away_team_season.r_assists / 0.15) * ((@home_team_season.assists_percentage - current_season.assists_percentage) / 1.5)
        end
        
        if @home_team_season.r_three_pointers > 0.1
          three_pointers_advantage += @home_team_season.three_pointers_advantage * (@home_team_season.r_three_pointers / 0.15) * ((@away_team_season.three_pointers_proficiency - current_season.three_pointers_proficiency) / 1.1)
        end
        
        if @away_team_season.r_three_pointers > 0.1
          three_pointers_advantage += -@away_team_season.three_pointers_advantage * (@away_team_season.r_three_pointers / 0.15) * ((@home_team_season.three_pointers_proficiency - current_season.three_pointers_proficiency) / 1.1)
        end
        
        if @home_team_season.r_pace > 0.1
          pace_advantage += @home_team_season.pace_advantage * (@home_team_season.r_pace   / 0.15) * ((@away_team_season.adj_tempo - current_season.adj_tempo) / 1.1)
        end
        
        if @away_team_season.r_pace > 0.1
          pace_advantage += -@away_team_season.pace_advantage * (@away_team_season.r_pace  / 0.15) * ((@home_team_season.adj_tempo - current_season.adj_tempo) / 1.1)
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
        @prediction.home_advantage = home_advantage.round(1)
        @prediction.defense_advantage = defensive_advantage.round(1)
        @prediction.assists_advantage = assists_advantage.round(1)
        @prediction.three_pointers_advantage = three_pointers_advantage.round(1)
        @prediction.pace_advantage = pace_advantage.round(1)
        predicted_home_score = predicted_home_efficiency * predicted_tempo / 100
        predicted_away_score = predicted_away_efficiency * predicted_tempo / 100
        @prediction.home_team_prediction = predicted_home_score.round
        @prediction.away_team_prediction = predicted_away_score.round
        @prediction.predicted_point_spread = (((predicted_away_score - predicted_home_score) * 2).round / 2.0)
        @prediction.predicted_over_under = (((predicted_away_score + predicted_home_score) * 2).round / 2.0)
        ##### MONEYLINE CALCS ######
        mean = predicted_home_efficiency - predicted_away_efficiency
        std_dev = Math.sqrt(2 * current_season.consistency ** 2) 
        home_win_z_score = (0.0 - mean) / std_dev
        home_win_probability = getProbability(home_win_z_score)
        @prediction.home_win_probability = (home_win_probability * 100.0).round(1)
        if home_win_probability > 0.5
          predicted_moneyline = (- (home_win_probability / (1 - home_win_probability)) * 100.0).round
          if predicted_moneyline < -10000
            @prediction.predicted_moneyline = nil
          else
            @prediction.predicted_moneyline = (predicted_moneyline / 10.0).round * 10
          end
        else
          predicted_moneyline = (((1 - home_win_probability) / home_win_probability) * 100.0).round
          if predicted_moneyline > 10000
            @prediction.predicted_moneyline = nil
          else
            @prediction.predicted_moneyline = (predicted_moneyline / 10.0).round * 10
          end
        end
      end
    else
      
    end
  end
end
