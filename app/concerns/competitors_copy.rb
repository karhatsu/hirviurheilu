module CompetitorsCopy
  extend ActiveSupport::Concern

  def copy_competitors_from(race)
    errors = []
    race.transaction do
      race.competitors.each do |competitor|
        club = ensure_club competitor.club
        series = ensure_series competitor.series
        age_group = ensure_age_group series, competitor.age_group
        create_competitor club, series, age_group, competitor if validate_competitor errors, competitor
      end
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

  def validate_competitor(errors, competitor)
    if competitors.find_by_number(competitor.number)
      errors << "Kilpailijanumero #{competitor.number} on jo käytössä tässä kilpailussa."
      return false
    end
    if start_order == Race::START_ORDER_MIXED && !competitor.start_time
      errors << 'Kohdekilpailu vaatii, että kilpailijoilla on lähtöajat mutta valitusta kilpailusta lähtöajat puuttuvat.'
      return false
    end
    true
  end

  def create_competitor(club, series, age_group, competitor)
    Competitor.create! club: club, series: series, age_group: age_group,
                       first_name: competitor.first_name, last_name: competitor.last_name,
                       number: competitor.number, start_time: competitor.start_time
  end
end