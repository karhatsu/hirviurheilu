module AssignModel
  def assign_cup_by_id
    assign_cup params[:id]
  end

  def assign_cup_by_cup_id
    assign_cup params[:cup_id]
  end

  def assign_cup(id)
    begin
      @cup = Cup.find(id)
    rescue ActiveRecord::RecordNotFound
      @id = id
      render 'errors/cup_not_found', status: 404
    end
  end

  def assign_race_with_optional_series
    @series = assign_series params[:series_id] if params[:series_id]
    @race = assign_race params[:race_id]
  end

  def assign_race_by_id
    assign_race params[:id]
  end

  def assign_race_by_race_id
    assign_race params[:race_id]
  end

  def assign_race(id)
    begin
      @race = Race.find(id)
    rescue ActiveRecord::RecordNotFound
      @id = id
      render 'errors/race_not_found', status: 404
    end
  end

  def assign_series_by_id
    assign_series params[:id]
  end

  def assign_series_by_series_id
    assign_series params[:series_id]
  end

  def assign_series(id)
    begin
      @series = Series.find(id)
    rescue ActiveRecord::RecordNotFound
      @id = id
      render 'errors/series_not_found', status: 404
    end
  end

  def assign_competitor_by_id
    @id = params[:id]
    begin
      @competitor = @series.competitors.find @id
    rescue ActiveRecord::RecordNotFound
      render 'errors/competitor_not_found', status: 404
    end
  end

  def assign_relay_by_id
    @id = params[:id]
    begin
      @relay = @race.relays.find @id
    rescue ActiveRecord::RecordNotFound
      render 'errors/relay_not_found', status: 404
    end
  end

  def assign_relay_by_relay_id
    @id = params[:relay_id]
    begin
      @relay = Relay.find @id
    rescue ActiveRecord::RecordNotFound
      render 'errors/relay_not_found', status: 404
    end
  end

  def assign_team_competition_by_id
    @id = params[:id]
    begin
      @tc = @race.team_competitions.find @id
    rescue ActiveRecord::RecordNotFound
      render 'errors/team_competition_not_found', status: 404
    end
  end

  def assign_cup_series_by_id
    @id = params[:id]
    begin
      @cup_series = @cup.cup_series.find(@id)
    rescue ActiveRecord::RecordNotFound
      render 'errors/cup_series_not_found', status: 404
    end
  end

  def assign_cup_team_competition_by_id
    @id = params[:id]
    begin
      @cup_series = @cup.cup_team_competitions.find(@id)
    rescue ActiveRecord::RecordNotFound
      render 'errors/cup_team_competition_not_found', status: 404
    end
  end
end
