module ApplicationHelper

  def points_print(competitor)
    return competitor.points unless competitor.points.nil?
    return "(#{competitor.points!})" unless competitor.points!.nil?
    "-"
  end

end
