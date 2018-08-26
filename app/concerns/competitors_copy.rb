module CompetitorsCopy
  extend ActiveSupport::Concern

  def copy_competitors_from(race, with_start_list)
    raise ArgumentError if start_order == Race::START_ORDER_MIXED && !with_start_list
    errors = []
    race.transaction do
      race.competitors.each do |competitor|
        club = ensure_club competitor.club
        series = ensure_series competitor.series
        age_group = ensure_age_group series, competitor.age_group
        next if competitor_already_exists series, competitor
        create_competitor club, series, age_group, competitor, with_start_list if validate_competitor errors, competitor
      end
      raise ActiveRecord::Rollback unless errors.empty?
    end
    errors
  end

  private

  def ensure_club(source_club)
    Club.find_or_create_by! race: self, name: source_club.name do |club|
      club.race = self
    end
  end

  def ensure_series(source_series)
    Series.find_or_create_by! race: self, name: source_series.name do |series|
      series.race = self
    end
  end

  def ensure_age_group(series, source_age_group)
    return nil unless source_age_group
    AgeGroup.find_or_create_by! series: series, name: source_age_group.name
  end

  def competitor_already_exists(series, competitor)
    Competitor.exists? series: series, first_name: competitor.first_name, last_name: competitor.last_name
  end

  def validate_competitor(errors, competitor)
    if competitor.number && competitors.find_by_number(competitor.number)
      errors << "Kilpailijanumero #{competitor.number} on jo käytössä tässä kilpailussa."
      return false
    end
    if start_order == Race::START_ORDER_MIXED && !competitor.start_time
      errors << 'Kohdekilpailu vaatii, että kilpailijoilla on lähtöajat mutta valitusta kilpailusta lähtöajat puuttuvat.'
      return false
    end
    true
  end

  def create_competitor(club, series, age_group, competitor, with_start_list)
    copied_competitor = Competitor.new club: club, series: series, age_group: age_group,
                       first_name: competitor.first_name, last_name: competitor.last_name
    if with_start_list
      copied_competitor.number = competitor.number
      copied_competitor.start_time = competitor.start_time
      series.update_attribute :has_start_list, true if competitor.number && !series.has_start_list?
    end
    copied_competitor.save!
  end
end