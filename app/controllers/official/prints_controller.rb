class Official::PrintsController < Official::OfficialController
  def index
    respond_to do |format|
      format.html do
        use_react true
        render layout: true, html: ''
      end
      format.pdf do
        @event = current_user.find_event(params[:event_id], races: [series: [competitors: :club]])
        return render status: 404, body: nil unless @event
        sort_competitors
        render pdf: "#{@event.name} - #{t('official.competitors.index.title')}", layout: true,
               margin: pdf_margin, header: pdf_header("#{@event.name} - #{t('official.competitors.index.title')}"),
               footer: pdf_footer, orientation: 'Portrait', disable_smart_shrinking: true
      end
    end
  end

  private

  def sort_competitors
    competitors_hash = {}
    @event.races.each do |race|
      race.series.each do |series|
        series.competitors.each do |competitor|
          key = "#{competitor.club.name}_#{competitor.last_name}_#{competitor.first_name}"
          unless competitors_hash[key]
            competitors_hash[key] = competitor
            competitors_hash[key].event_races = []
          end
          competitors_hash[key].event_races << [competitor.series.name, competitor.series.race.name]
        end
      end
    end
    @competitors = competitors_hash.values.sort { |a, b|
      if params[:order] == 'numbers'
        [a.number, a.last_name, a.first_name] <=> [b.number, b.last_name, b.first_name]
      elsif params[:order] == 'clubAlphabetical'
        [a.club.name, a.last_name, a.first_name] <=> [b.club.name, b.last_name, b.first_name]
      elsif params[:order] == 'clubNumbers'
        [a.club.name, a.number, a.last_name, a.first_name] <=> [b.club.name, b.number, b.last_name, b.first_name]
      else
        [a.last_name, a.first_name] <=> [b.last_name, b.first_name]
      end
    }
  end
end
