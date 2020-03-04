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
    last_one_in = @bracketology.tournament_field.index(@bracketology.last_four_in[3])
    last_two_in = @bracketology.tournament_field.index(@bracketology.last_four_in[2])
    puts last_one_in
    puts last_two_in
    #### Play in Games ####
    @bracketology.round_of_sixtyfour = []
    for n in 0..31
      m = 65 - n
      if m <= last_two_in
        m += -2
      elsif m <= last_one_in
        m += -1
      end
      if m > last_one_in
        @bracketology.round_of_sixtyfour << { top: @bracketology.tournament_field[n], bottom: @bracketology.tournament_field[m], top_score: 0, bottom_score: 0, top_seed: ((n + 1) / 4.0).ceil, bottom_seed: ((m - 1) / 4.0).ceil }
      else
        @bracketology.round_of_sixtyfour << { top: @bracketology.tournament_field[n], bottom: @bracketology.tournament_field[m], top_score: 0, bottom_score: 0, top_seed: ((n + 1) / 4.0).ceil, bottom_seed: ((m + 1) / 4.0).ceil }
      end
    end
    #### First Round ####
    @bracketology.round_of_thirtytwo = []
    thirty_two = []
    thirty_two_seeds = []
    for x in 0..31
      top = TeamSeason.find(@bracketology.round_of_sixtyfour[x][:top])
      bottom = TeamSeason.find(@bracketology.round_of_sixtyfour[x][:bottom])
      fav_p = rand()
      fav_z = getZscore(fav_p)
      und_z = getZscore(rand())
      pace_z = getZscore(rand())
      predicted_tempo = top.adj_tempo + bottom.adj_tempo - current_season.adj_tempo
      pace_standard_dev = 6.5
      top_efficiency = (top.adj_offensive_efficiency + bottom.adj_defensive_efficiency - current_season.adj_offensive_efficiency) + (fav_z * current_season.consistency)
      bottom_efficiency = (top.adj_defensive_efficiency + bottom.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (und_z * current_season.consistency)
      tempo = predicted_tempo + (pace_z * pace_standard_dev)
      top_score = tempo * top_efficiency / 100
      bottom_score = tempo * bottom_efficiency / 100
      if top_score.round == bottom_score.round
        if top_score > bottom_score
          top_score += 1.0
        else
          bottom_score += 1.0
        end
      end
      @bracketology.round_of_sixtyfour[x][:top_score] = top_score
      @bracketology.round_of_sixtyfour[x][:bottom_score] = bottom_score

      if top_score > bottom_score
        thirty_two << @bracketology.round_of_sixtyfour[x][:top]
        thirty_two_seeds << @bracketology.round_of_sixtyfour[x][:top_seed]
      else
        thirty_two << @bracketology.round_of_sixtyfour[x][:bottom]
        thirty_two_seeds << @bracketology.round_of_sixtyfour[x][:bottom_seed]
      end
    end
    @bracketology.round_of_thirtytwo << { top: thirty_two[0], bottom: thirty_two[31], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[0], bottom_seed: thirty_two_seeds[31] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[16], bottom: thirty_two[15], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[16], bottom_seed: thirty_two_seeds[15] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[23], bottom: thirty_two[8], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[23], bottom_seed: thirty_two_seeds[8] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[24], bottom: thirty_two[7], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[24], bottom_seed: thirty_two_seeds[7] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[3], bottom: thirty_two[28], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[3], bottom_seed: thirty_two_seeds[28] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[19], bottom: thirty_two[12], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[19], bottom_seed: thirty_two_seeds[12] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[20], bottom: thirty_two[11], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[20], bottom_seed: thirty_two_seeds[11] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[24], bottom: thirty_two[4], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[24], bottom_seed: thirty_two_seeds[4] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[1], bottom: thirty_two[30], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[1], bottom_seed: thirty_two_seeds[30] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[17], bottom: thirty_two[14], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[17], bottom_seed: thirty_two_seeds[14] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[22], bottom: thirty_two[9], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[22], bottom_seed: thirty_two_seeds[9] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[25], bottom: thirty_two[6], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[25], bottom_seed: thirty_two_seeds[6]}
    @bracketology.round_of_thirtytwo << { top: thirty_two[2], bottom: thirty_two[29], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[2], bottom_seed: thirty_two_seeds[29] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[18], bottom: thirty_two[13], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[18], bottom_seed: thirty_two_seeds[13] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[21], bottom: thirty_two[10], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[21], bottom_seed: thirty_two_seeds[10] }
    @bracketology.round_of_thirtytwo << { top: thirty_two[26], bottom: thirty_two[5], top_score: 0, bottom_score: 0, top_seed: thirty_two_seeds[26], bottom_seed: thirty_two_seeds[5] }
    #### Second Round ####
    @bracketology.round_of_sixteen = []
    first_team = 0
    first_seed = 0
    for x in 0..15
      top = TeamSeason.find(@bracketology.round_of_thirtytwo[x][:top])
      bottom = TeamSeason.find(@bracketology.round_of_thirtytwo[x][:bottom])
      fav_p = rand()
      fav_z = getZscore(fav_p)
      und_z = getZscore(rand())
      pace_z = getZscore(rand())
      predicted_tempo = top.adj_tempo + bottom.adj_tempo - current_season.adj_tempo
      top_efficiency = (top.adj_offensive_efficiency + bottom.adj_defensive_efficiency - current_season.adj_offensive_efficiency) + (fav_z * current_season.consistency)
      bottom_efficiency = (top.adj_defensive_efficiency + bottom.adj_offensive_efficiency - current_season.adj_offensive_efficiency) + (und_z * current_season.consistency)
      tempo = predicted_tempo + (pace_z * pace_standard_dev)
      top_score = tempo * top_efficiency / 100
      bottom_score = tempo * bottom_efficiency / 100
      if top_score.round == bottom_score.round
        if top_score > bottom_score
          top_score += 1.0
        else
          bottom_score += 1.0
        end
      end
      @bracketology.round_of_thirtytwo[x][:top_score] = top_score
      @bracketology.round_of_thirtytwo[x][:bottom_score] = bottom_score
      if (x + 1) % 2 == 0 
        if top_score > bottom_score
          @bracketology.round_of_sixteen << { top: first_team, bottom: @bracketology.round_of_thirtytwo[x][:top], top_score: 0, bottom_score: 0, top_seed: first_seed , bottom_seed: @bracketology.round_of_thirtytwo[x][:top_seed] }
        else
          @bracketology.round_of_sixteen << { top: first_team, bottom: @bracketology.round_of_thirtytwo[x][:bottom], top_score: 0, bottom_score: 0, top_seed: first_seed , bottom_seed: @bracketology.round_of_thirtytwo[x][:bottom_seed] }
        end
      else
        if top_score > bottom_score
          first_team = @bracketology.round_of_thirtytwo[x][:top]
          first_seed = @bracketology.round_of_thirtytwo[x][:top_seed]
        else
          first_team = @bracketology.round_of_thirtytwo[x][:bottom]
          first_seed = @bracketology.round_of_thirtytwo[x][:bottom_seed]
        end
      end
    end
    @bracketology.save
  end
end
