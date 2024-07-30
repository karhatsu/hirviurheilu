class Official::HeatListsController < Official::OfficialController
  private

  def build_opts
    opts = {}
    opts[:first_heat_track_number] = params[:first_heat_track_number].to_i unless params[:first_heat_track_number].blank?
    opts[:include_tracks] = params[:include_tracks]&.map {|i| i.to_i}
    opts[:heat_day] = params[:heat_day].to_i unless params[:heat_day].blank?
    opts[:only_track_places] = params[:only_track_places]
    opts[:skip_first_track_place] = params[:skip_first_track_place]
    opts[:skip_last_track_place] = params[:skip_last_track_place]
    opts[:skip_track_places] = params[:skip_track_places].split(',').map(&:strip).map(&:to_i)
    opts
  end
end
