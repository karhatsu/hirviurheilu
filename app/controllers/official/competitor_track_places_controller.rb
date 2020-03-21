class Official::CompetitorTrackPlacesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def update
    competitor = @race.competitors.find(params[:competitor_id])
    if competitor
      batch = @race.batches.find params[:batch_id]
      batch_id_field = batch.final_round? ? :final_round_batch_id : :qualification_round_batch_id
      track_place_field = batch.final_round? ? :final_round_track_place : :qualification_round_track_place
      competitor.transaction do
        batch_id = params[:batch_id]
        track_place = params[:track_place]
        competitor[batch_id_field] = batch_id
        competitor[track_place_field] = track_place
        previous_competitor = @race.competitors.where("#{batch_id_field}=? AND #{track_place_field}=?", batch_id, track_place).first
        if competitor.save
          if previous_competitor
            previous_competitor[batch_id_field] = nil
            previous_competitor[track_place_field] = nil
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
      batch_id_field = params[:final_round] ? :final_round_batch_id : :qualification_round_batch_id
      track_place_field = params[:final_round] ? :final_round_track_place : :qualification_round_track_place
      competitor[batch_id_field] = nil
      competitor[track_place_field] = nil
      competitor.save!
      render status: 204, json: nil
    else
      render status: 404, json: nil
    end
  end
end
