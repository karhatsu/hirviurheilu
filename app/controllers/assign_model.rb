module AssignModel
  def assign_cup_by_id
    assign_cup params[:id]
  end

  def assign_cup(id)
    begin
      @cup = Cup.find(id)
    rescue ActiveRecord::RecordNotFound
      set_variant
      @id = id
      render 'errors/cup_not_found'
    end
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
      set_variant
      @id = id
      render 'errors/race_not_found'
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
      set_variant
      @id = id
      render 'errors/series_not_found'
    end
  end

  def assign_competitor_by_id
    assign_competitor params[:id]
  end

  def assign_competitor(id)
    begin
      @competitor = Competitor.find(id)
    rescue ActiveRecord::RecordNotFound
      set_variant
      @id = id
      render 'errors/competitor_not_found'
    end
  end

  def assign_relay_by_id
    assign_relay params[:id]
  end

  def assign_relay_by_relay_id
    assign_relay params[:relay_id]
  end

  def assign_relay(id)
    begin
      @relay = Relay.find(id)
    rescue ActiveRecord::RecordNotFound
      set_variant
      @id = id
      render 'errors/relay_not_found'
    end
  end

  def assign_team_competition_by_id
    assign_team_competition params[:id]
  end

  def assign_team_competition_by_team_competition_id
    assign_team_competition params[:team_competition_id]
  end

  def assign_team_competition(id)
    begin
      @tc = TeamCompetition.find(id)
    rescue ActiveRecord::RecordNotFound
      set_variant
      @id = id
      render 'errors/team_competition_not_found'
    end
  end

  def assign_cup_series_by_id
    @id = params[:id]
    begin
      @cup_series = @cup.cup_series.find(@id)
    rescue ActiveRecord::RecordNotFound
      render 'errors/cup_series_not_found'
    end
  end
end