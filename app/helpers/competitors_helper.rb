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
end