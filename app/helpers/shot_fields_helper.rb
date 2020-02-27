module ShotFieldsHelper
  def shot_fields_config(sport, competitor)
    config = Hash.new
    qualification_round = sport.qualification_round
    qualification_round_shots_count = qualification_round && qualification_round.inject(:+) || 0
    final_round = sport.final_round
    final_round_shots_count = final_round && final_round.inject(:+) || 0
    basic_shots_count = qualification_round_shots_count + final_round_shots_count
    shots_per_extra_round = sport.shots_per_extra_round
    config[:qualification_round] = qualification_round
    config[:qualification_round_shots_count] = qualification_round_shots_count
    config[:final_round] = final_round
    config[:extra_shots_count] = competitor.shots && competitor.shots.length == basic_shots_count ? (competitor.extra_shots || []).length + shots_per_extra_round : 0
    config
  end
end
