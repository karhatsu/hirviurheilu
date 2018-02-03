module UnofficialsHelper
  def unofficials_result_rule(race)
    return Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME if race.start_date.year >= 2018
    return Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME if params[:all_competitors]
    Series::UNOFFICIALS_EXCLUDED
  end
end