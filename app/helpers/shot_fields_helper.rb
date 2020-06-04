module ShotFieldsHelper
  def shot_fields_config(sport, competitor)
    config = Hash.new
    shots_per_extra_round = sport.shots_per_extra_round
    config[:qualification_round] = sport.qualification_round
    config[:qualification_round_shot_count] = sport.qualification_round_shot_count
    config[:final_round] = sport.final_round
    config[:extra_shots_count] = 0
    if competitor.final_round_shooting_score_input || (competitor.shots && competitor.shots.length == sport.shot_count)
      config[:extra_shots_count] = (competitor.extra_shots || []).length + shots_per_extra_round
    end
    config[:best_shot_value] = sport.best_shot_value
    config
  end

  def nordic_extra_shots_field_count(competitor, sub_sport, shots_count)
    score_input = competitor.send("nordic_#{sub_sport}_score_input")
    shots = competitor.send("nordic_#{sub_sport}_shots")
    if score_input || (shots && shots.length == shots_count)
      extra_shots = competitor.send("nordic_#{sub_sport}_extra_shots")
      config = NordicSubSport.by_key sub_sport
      return (extra_shots || []).length + config.shots_per_extra_round
    end
    0
  end
end
