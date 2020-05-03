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
    config
  end
end
