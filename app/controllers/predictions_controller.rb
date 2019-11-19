class PredictionsController < ApplicationController
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction
  def index
    @games = Game.where(day: params[:date]).order("#{sort_column} #{sort_direction}")
    @predictions = Prediction.where(day: params[:date])
  end
  
  def show
    @prediction = Prediction.find(params[:id])
    @game = @prediction.game
    @home_team_season = TeamSeason.find_by(team: @game.home_team, season: @game.season)
    @away_team_season = TeamSeason.find_by(team: @game.away_team, season: @game.season)
    away_player_season_ids = []
    home_player_season_ids = []
    year = @game.year
    if @game.away_team
      @game.away_team.player_seasons.where(year: year).each do |player|
        away_player_season_ids << player.id
      end
    end
    if @game.home_team
      @game.home_team.player_seasons.where(year: year).each do |player|
        home_player_season_ids << player.id
      end
    end
    @away_player_seasons = PlayerSeason.find(away_player_season_ids)
    @home_player_seasons = PlayerSeason.find(home_player_season_ids)
    if @away_player_seasons.count > 0
      begin
        away_max_minutes = @away_player_seasons.sort_by(&:minutes).reverse.first.minutes
        away_min_minutes = away_max_minutes * 0.4
        away_qualified_players = @away_player_seasons.select {|qualified| qualified["minutes"] > away_min_minutes}
        @away_points_leader = away_qualified_players.max_by{|z| z[:points_per_game]}
        @away_assists_leader = away_qualified_players.max_by{|y| y[:assists]}
        @away_rebounds_leader = away_qualified_players.max_by{|x| x[:rebounds_per_game]}
        @away_prate_leader = away_qualified_players.max_by{|u| u[:prophet_rating]}
      rescue
      
      end
    end
    if @home_player_seasons. count > 0
      begin
        home_max_minutes = @home_player_seasons.sort_by(&:minutes).reverse.first.minutes
        home_min_minutes = home_max_minutes * 0.4
        home_qualified_players = @home_player_seasons.select {|qualified| qualified["minutes"] > home_min_minutes}
        @home_points_leader = home_qualified_players.max_by{|z| z[:points_per_game]}
        @home_assists_leader = home_qualified_players.max_by{|y| y[:assists]}
        @home_rebounds_leader = home_qualified_players.max_by{|x| x[:rebounds_per_game]}
        @home_prate_leader = home_qualified_players.max_by{|u| u[:prophet_rating]}
      rescue
      
      end
    end
    

  end
  
  def statistics
    if params[:season]
      @season = Season.find_by(season: params[:season])
      @predictions = Prediction.where(season: @season)
    else
      @season = current_season
      @predictions = Prediction.where(season: @season)
    end
    @point_spread_wins = @predictions.where(win_point_spread: true).count
    @point_spread_losses = @predictions.where(win_point_spread: false).count
    @over_under_wins = @predictions.where(win_over_under: true).count
    @over_under_losses = @predictions.where(win_over_under: false).count
    @moneyline_wins = @predictions.where(win_moneyline: true).count
    @moneyline_losses = @predictions.where(win_moneyline: false).count
    @straight_up_wins = @predictions.where(win_straight_up: true).count
    @straight_up_losses = @predictions.where(win_straight_up: false).count
    @favorite_wins = @predictions.where(favorite_favorite: true, win_point_spread: true).count
    @favorite_losses = @predictions.where(favorite_favorite: true, win_point_spread: false).count
    @underdog_wins = @predictions.where(favorite_favorite: false, win_point_spread: true).count
    @underdog_losses = @predictions.where(favorite_favorite: false, win_point_spread: false).count
    @fast_pace_wins = @predictions.where(pace_favorite: true, win_point_spread: true).count
    @fast_pace_losses = @predictions.where(pace_favorite: true, win_point_spread: false).count
    @slow_pace_wins = @predictions.where(pace_favorite: false, win_point_spread: true).count
    @slow_pace_losses = @predictions.where(pace_favorite: false, win_point_spread: false).count
    @over_wins = @predictions.where(over_under_bet: "OVER", win_over_under: true).count
    @over_losses = @predictions.where(over_under_bet: "OVER", win_over_under: false).count
    @under_wins = @predictions.where(over_under_bet: "UNDER", win_over_under: true).count
    @under_losses = @predictions.where(over_under_bet: "UNDER", win_over_under: false).count
  end
  private
    def sortable_columns
      ['date_time', 'thrill_score']
    end
    
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'date_time'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "asc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
end
