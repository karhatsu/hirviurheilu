class Official::CompetitorTrackPlacesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def update
    competitor = @race.competitors.find(params[:competitor_id])
    if competitor
      competitor.transaction do
        batch_id = params[:batch_id]
        track_place = params[:track_place]
        competitor.batch_id = batch_id
        competitor.track_place = track_place
        previous_competitor = @race.competitors.where('batch_id=? AND track_place=?', batch_id, track_place).first
        if competitor.save
          if previous_competitor
            previous_competitor.batch_id = nil
            previous_competitor.track_place = nil
            previous_competitor.save!
          end
          render json: competitor, only: [:id, :first_name, :last_name], methods: [:series_name]
        else
          render status: 400, json: { error: competitor.errors.full_messages.join('. ') }
        end
      end
    else
      render status: 404, json: nil
    end
  end

  def destroy
    competitor = @race.competitors.find(params[:competitor_id])
    if competitor
      competitor.batch_id = nil
      competitor.track_place = nil
      competitor.save!
      render status: 204, json: nil
    else
      render status: 404, json: nil
    end
  end
end
