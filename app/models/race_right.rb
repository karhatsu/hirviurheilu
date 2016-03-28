class RaceRight < ActiveRecord::Base
  belongs_to :user
  belongs_to :race
  belongs_to :club

  before_update :reset_club_id_for_full_rights

  private

  def reset_club_id_for_full_rights
    self.club_id = nil unless only_add_competitors
  end
end