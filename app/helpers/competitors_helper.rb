module CompetitorsHelper
  def handle_club(competitor)
    club_id_given = (params[:club_id] and params[:club_id].to_i != 0)
    competitor.club_id = params[:club_id] if club_id_given
    unless club_id_given or params[:club_name].blank?
      new_name = params[:club_name]
      existing_club = competitor.series.race.clubs.find_by_name(new_name)
      if existing_club
        competitor.club = existing_club
      else
        competitor.club = Club.create!(:race => competitor.series.race, :name => new_name)
      end
    end
    # Cucumber hack
    if Rails.env.test?
      if competitor.club.nil? and competitor.club_id.nil? and params[:club]
        competitor.club_id = params[:club]
      end
    end
    unless competitor.club_id
      # have to do this here instead of the competitor model since cannot have
      # the presence validation for club due to the nested forms usage
      competitor.errors.add :club, :empty
      return false
    end
    true
  end

  def set_shots(competitor, shots_column, shots_params)
    return true if shots_params.blank?
    if empty_shots_in_between?(shots_params)
      competitor.errors.add :base, 'Osa laukauksista on jätetty tyhjiksi. Käytä nollaa ohilaukauksille.'
      return false
    end
    shots = shots_params.reject{|s| s.blank?}
    if shots.length > 0
      competitor.send "#{shots_column}=", shots
    else
      competitor.send "#{shots_column}=", nil
    end
    true
  end

  private

  def empty_shots_in_between?(shots)
    blanks_in_between = false
    shots.each_with_index do |shot, i|
      blanks_in_between ||= i > 0 && !shot.blank? && shots[i - 1].blank?
    end
    blanks_in_between
  end
end
