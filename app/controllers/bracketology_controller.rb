class BracketologyController < ApplicationController
  include Gaussian
  
  def show
    if params[:id]
      @bracketology = Bracketology.find_by(id: params[:id])
    else
      @bracketology = Bracketology.order(date: :desc).first
    end
    @one = TeamSeason.find(@bracketology.tournament_field[0])
    @two = TeamSeason.find(@bracketology.tournament_field[1])
    @three = TeamSeason.find(@bracketology.tournament_field[2])
    @four = TeamSeason.find(@bracketology.tournament_field[3])
    @five = TeamSeason.find(@bracketology.tournament_field[4])
    @six = TeamSeason.find(@bracketology.tournament_field[5])
    @seven = TeamSeason.find(@bracketology.tournament_field[6])
    @eight = TeamSeason.find(@bracketology.tournament_field[7])
    @nine = TeamSeason.find(@bracketology.tournament_field[8])
    @ten = TeamSeason.find(@bracketology.tournament_field[9])
    @eleven = TeamSeason.find(@bracketology.tournament_field[10])
    @twelve = TeamSeason.find(@bracketology.tournament_field[11])
    @thirteen = TeamSeason.find(@bracketology.tournament_field[12])
    @fourteen = TeamSeason.find(@bracketology.tournament_field[13])
    @fifteen = TeamSeason.find(@bracketology.tournament_field[14])
    @sixteen = TeamSeason.find(@bracketology.tournament_field[15])
    @seventeen = TeamSeason.find(@bracketology.tournament_field[16])
    @eighteen = TeamSeason.find(@bracketology.tournament_field[17])
    @nineteen = TeamSeason.find(@bracketology.tournament_field[18])
    @twenty = TeamSeason.find(@bracketology.tournament_field[19])
    @twentyone = TeamSeason.find(@bracketology.tournament_field[20])
    @twentytwo = TeamSeason.find(@bracketology.tournament_field[21])
    @twentythree = TeamSeason.find(@bracketology.tournament_field[22])
    @twentyfour = TeamSeason.find(@bracketology.tournament_field[23])
    @twentyfive = TeamSeason.find(@bracketology.tournament_field[24])
    @twentysix = TeamSeason.find(@bracketology.tournament_field[25])
    @twentyseven = TeamSeason.find(@bracketology.tournament_field[26])
    @twentyeight = TeamSeason.find(@bracketology.tournament_field[27])
    @twentynine = TeamSeason.find(@bracketology.tournament_field[28])
    @thirty = TeamSeason.find(@bracketology.tournament_field[29])
    @thirtyone = TeamSeason.find(@bracketology.tournament_field[30])
    @thirtytwo = TeamSeason.find(@bracketology.tournament_field[31])
    @thirtythree = TeamSeason.find(@bracketology.tournament_field[32])
    @thirtyfour = TeamSeason.find(@bracketology.tournament_field[33])
    @thirtyfive = TeamSeason.find(@bracketology.tournament_field[34])
    @thirtysix = TeamSeason.find(@bracketology.tournament_field[35])
    @thirtyseven = TeamSeason.find(@bracketology.tournament_field[36])
    @thirtyeight = TeamSeason.find(@bracketology.tournament_field[37])
    @thirtynine = TeamSeason.find(@bracketology.tournament_field[38])
    @forty = TeamSeason.find(@bracketology.tournament_field[39])
    @fortyone = TeamSeason.find(@bracketology.tournament_field[40])
    @fortytwo = TeamSeason.find(@bracketology.tournament_field[41])
    @fortythree = TeamSeason.find(@bracketology.tournament_field[42])
    @fortyfour = TeamSeason.find(@bracketology.tournament_field[43])
    @fortyfive = TeamSeason.find(@bracketology.tournament_field[44])
    @fortysix = TeamSeason.find(@bracketology.tournament_field[45])
    @fortyseven = TeamSeason.find(@bracketology.tournament_field[46])
    @fortyeight = TeamSeason.find(@bracketology.tournament_field[47])
    @fortynine = TeamSeason.find(@bracketology.tournament_field[48])
    @fifty = TeamSeason.find(@bracketology.tournament_field[49])
    @fiftyone = TeamSeason.find(@bracketology.tournament_field[50])
    @fiftytwo = TeamSeason.find(@bracketology.tournament_field[51])
    @fiftythree = TeamSeason.find(@bracketology.tournament_field[52])
    @fiftyfour = TeamSeason.find(@bracketology.tournament_field[53])
    @fiftyfive = TeamSeason.find(@bracketology.tournament_field[54])
    @fiftysix = TeamSeason.find(@bracketology.tournament_field[55])
    @fiftyseven = TeamSeason.find(@bracketology.tournament_field[56])
    @fiftyeight = TeamSeason.find(@bracketology.tournament_field[57])
    @fiftynine = TeamSeason.find(@bracketology.tournament_field[58])
    @sixty = TeamSeason.find(@bracketology.tournament_field[59])
    @sixtyone = TeamSeason.find(@bracketology.tournament_field[60])
    @sixtytwo = TeamSeason.find(@bracketology.tournament_field[61])
    @sixtythree = TeamSeason.find(@bracketology.tournament_field[62])
    @sixtyfour = TeamSeason.find(@bracketology.tournament_field[63])
    @sixtyfive = TeamSeason.find(@bracketology.tournament_field[64])
    @sixtysix = TeamSeason.find(@bracketology.tournament_field[65])
    @sixtyseven = TeamSeason.find(@bracketology.tournament_field[66])
    @sixtyeight = TeamSeason.find(@bracketology.tournament_field[67])
    
    # Last Four Byes 
    @bye_one = TeamSeason.find(@bracketology.last_four_byes[0])
    @bye_two = TeamSeason.find(@bracketology.last_four_byes[1])
    @bye_three = TeamSeason.find(@bracketology.last_four_byes[2])
    @bye_four = TeamSeason.find(@bracketology.last_four_byes[3])
    
    # Last Four In 
    @last_one = TeamSeason.find(@bracketology.last_four_in[0])
    @last_two = TeamSeason.find(@bracketology.last_four_in[1])
    @last_three = TeamSeason.find(@bracketology.last_four_in[2])
    @last_four = TeamSeason.find(@bracketology.last_four_in[3])
    
    # First Four Out
    @first_one = TeamSeason.find(@bracketology.first_four_out[0])
    @first_two = TeamSeason.find(@bracketology.first_four_out[1])
    @first_three = TeamSeason.find(@bracketology.first_four_out[2])
    @first_four = TeamSeason.find(@bracketology.first_four_out[3])
    
    # Next Four Out
    @next_one = TeamSeason.find(@bracketology.next_four_out[0])
    @next_two = TeamSeason.find(@bracketology.next_four_out[1])
    @next_three = TeamSeason.find(@bracketology.next_four_out[2])
    @next_four = TeamSeason.find(@bracketology.next_four_out[3])
    
    @last_one_spot = @bracketology.tournament_field.index(@bracketology.last_four_in[0])
    @last_two_spot = @bracketology.tournament_field.index(@bracketology.last_four_in[1])
    @last_four_spot = @bracketology.tournament_field.index(@bracketology.last_four_in[3])
    @between_count = @last_four_spot - @last_one_spot - 2
    @eleven_twelve = []
    x = 0
    until @eleven_twelve.count == 10
      unless @bracketology.last_four_in.index(@bracketology.tournament_field[@last_one_spot + x])
        @eleven_twelve << @bracketology.tournament_field[@last_one_spot + x]
      end
      x += 1
    end
  end
  
  def simulate
    if params[:id]
      @bracketology = Bracketology.find_by(id: params[:id])
    else
      @bracketology = Bracketology.order(date: :desc).first
    end
    one_std_dev = Math.sqrt(2 * (current_season.consistency ** 2))
    two_std_dev = Math.sqrt(2 * (one_std_dev ** 2))
    scoring_std_dev = Math.sqrt(100 + (two_std_dev ** 2))
    #### Play in Games ####
    @bracketology.round_of_sixtyfour = []
    @bracketology.round_of_sixtyfour << { favorite: @bracketology.tournament_field[0], underdog: @bracketology.tournament_field[65], favorite_score: 0, underdog_score: 0, winner: nil }
    @bracketology.round_of_sixtyfour << { favorite: @bracketology.tournament_field[1], underdog: @bracketology.tournament_field[64], favorite_score: 0, underdog_score: 0, winner: nil }
    
    #### First Round ####
    for x in 0..1
      favorite = TeamSeason.find(@bracketology.round_of_sixtyfour[x][:favorite])
      underdog = TeamSeason.find(@bracketology.round_of_sixtyfour[x][:underdog])
      fav_p = rand()
      fav_z = getZscore(fav_p)
      und_z = getZscore(rand())
      pace_z = getZscore(rand())
      predicted_tempo = favorite.adj_tempo + underdog.adj_tempo - current_season.adj_tempo
      pace_standard_dev = 9.0
      favorite_efficiency = (favorite.adj_offensive_efficiency + underdog.adj_defensive_efficiency - current_season.adj_offensive_efficiency) + (fav_z * current_season.consistency)
      underdog_efficiency = (favorite.adj_defensive_efficiency + underdog.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (und_z * current_season.consistency)
      tempo = predicted_tempo + (pace_z * pace_standard_dev)
      @bracketology.round_of_sixtyfour[x][:favorite_score] = tempo * favorite_efficiency / 100
      @bracketology.round_of_sixtyfour[x][:underdog_score] = tempo * underdog_efficiency / 100
    end
    
    @bracketology.save
  end
end
