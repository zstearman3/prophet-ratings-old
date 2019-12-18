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
    else
      @season = current_season
    end
    @predictions = Prediction.where(season: @season)
    @month_predictions = @predictions.where("day > ?", Date.today - 32.days)
    @week_predictions = @predictions.where("day > ?", Date.today - 8.days)
    point_spread_wins = @predictions.where(win_point_spread: true)
    point_spread_losses = @predictions.where(win_point_spread: false)
    over_under_wins = @predictions.where(win_over_under: true)
    over_under_losses = @predictions.where(win_over_under: false)
    moneyline_wins = @predictions.where(win_moneyline: true)
    moneyline_losses = @predictions.where(win_moneyline: false)
    straight_up_wins = @predictions.where(win_straight_up: true)
    straight_up_losses = @predictions.where(win_straight_up: false)
    favorite_wins = @predictions.where(favorite_favorite: true, win_point_spread: true)
    favorite_losses = @predictions.where(favorite_favorite: true, win_point_spread: false)
    underdog_wins = @predictions.where(favorite_favorite: false, win_point_spread: true)
    underdog_losses = @predictions.where(favorite_favorite: false, win_point_spread: false)
    fast_pace_wins = @predictions.where(pace_favorite: true, win_point_spread: true)
    fast_pace_losses = @predictions.where(pace_favorite: true, win_point_spread: false)
    slow_pace_wins = @predictions.where(pace_favorite: false, win_point_spread: true)
    slow_pace_losses = @predictions.where(pace_favorite: false, win_point_spread: false)
    over_wins = @predictions.where(over_under_bet: "OVER", win_over_under: true)
    over_losses = @predictions.where(over_under_bet: "OVER", win_over_under: false)
    under_wins = @predictions.where(over_under_bet: "UNDER", win_over_under: true)
    under_losses = @predictions.where(over_under_bet: "UNDER", win_over_under: false)
    @point_spread_wins = point_spread_wins.count
    @point_spread_losses = point_spread_losses.count
    @over_under_wins = over_under_wins.count
    @over_under_losses = over_under_losses.count
    @moneyline_wins = moneyline_wins.count
    @moneyline_losses = moneyline_losses.count
    @straight_up_wins = straight_up_wins.count
    @straight_up_losses = straight_up_losses.count
    @favorite_wins = favorite_wins.count
    @favorite_losses = favorite_losses.count
    @underdog_wins = underdog_wins.count
    @underdog_losses = underdog_losses.count
    @fast_pace_wins = fast_pace_wins.count
    @fast_pace_losses = fast_pace_losses.count
    @slow_pace_wins = slow_pace_wins.count
    @slow_pace_losses = slow_pace_losses.count
    @over_wins = over_wins.count
    @over_losses = over_losses.count
    @under_wins = under_wins.count
    @under_losses = under_losses.count
    @month_point_spread_wins = point_spread_wins.where("day > ?", Date.today - 32.days).count
    @month_point_spread_losses = point_spread_losses.where("day > ?", Date.today - 32.days).count
    @month_over_under_wins = over_under_wins.where("day > ?", Date.today - 32.days).count
    @month_over_under_losses = over_under_losses.where("day > ?", Date.today - 32.days).count
    @month_moneyline_wins = moneyline_wins.where("day > ?", Date.today - 32.days).count
    @month_moneyline_losses = moneyline_losses.where("day > ?", Date.today - 32.days).count
    @month_straight_up_wins = straight_up_wins.where("day > ?", Date.today - 32.days).count
    @month_straight_up_losses = straight_up_losses.where("day > ?", Date.today - 32.days).count
    @month_favorite_wins = favorite_wins.where("day > ?", Date.today - 32.days).count
    @month_favorite_losses = favorite_losses.where("day > ?", Date.today - 32.days).count
    @month_underdog_wins = underdog_wins.where("day > ?", Date.today - 32.days).count
    @month_underdog_losses = underdog_losses.where("day > ?", Date.today - 32.days).count
    @month_fast_pace_wins = fast_pace_wins.where("day > ?", Date.today - 32.days).count
    @month_fast_pace_losses = fast_pace_losses.where("day > ?", Date.today - 32.days).count
    @month_slow_pace_wins = slow_pace_wins.where("day > ?", Date.today - 32.days).count
    @month_slow_pace_losses = slow_pace_losses.where("day > ?", Date.today - 32.days).count
    @month_over_wins = over_wins.where("day > ?", Date.today - 32.days).count
    @month_over_losses = over_losses.where("day > ?", Date.today - 32.days).count
    @month_under_wins = under_wins.where("day > ?", Date.today - 32.days).count
    @month_under_losses = under_losses.where("day > ?", Date.today - 32.days).count
    @week_point_spread_wins = point_spread_wins.where("day > ?", Date.today - 8.days).count
    @week_point_spread_losses = point_spread_losses.where("day > ?", Date.today - 8.days).count
    @week_over_under_wins = over_under_wins.where("day > ?", Date.today - 8.days).count
    @week_over_under_losses = over_under_losses.where("day > ?", Date.today - 8.days).count
    @week_moneyline_wins = moneyline_wins.where("day > ?", Date.today - 8.days).count
    @week_moneyline_losses = moneyline_losses.where("day > ?", Date.today - 8.days).count
    @week_straight_up_wins = straight_up_wins.where("day > ?", Date.today - 8.days).count
    @week_straight_up_losses = straight_up_losses.where("day > ?", Date.today - 8.days).count
    @week_favorite_wins = favorite_wins.where("day > ?", Date.today - 8.days).count
    @week_favorite_losses = favorite_losses.where("day > ?", Date.today - 8.days).count
    @week_underdog_wins = underdog_wins.where("day > ?", Date.today - 8.days).count
    @week_underdog_losses = underdog_losses.where("day > ?", Date.today - 8.days).count
    @week_fast_pace_wins = fast_pace_wins.where("day > ?", Date.today - 8.days).count
    @week_fast_pace_losses = fast_pace_losses.where("day > ?", Date.today - 8.days).count
    @week_slow_pace_wins = slow_pace_wins.where("day > ?", Date.today - 8.days).count
    @week_slow_pace_losses = slow_pace_losses.where("day > ?", Date.today - 8.days).count
    @week_over_wins = over_wins.where("day > ?", Date.today - 8.days).count
    @week_over_losses = over_losses.where("day > ?", Date.today - 8.days).count
    @week_under_wins = under_wins.where("day > ?", Date.today - 8.days).count
    @week_under_losses = under_losses.where("day > ?", Date.today - 8.days).count

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
