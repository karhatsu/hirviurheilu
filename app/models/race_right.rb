class RaceRight < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :club

  validate :check_club_limitation

  before_update :reset_club_id_for_full_rights

  private

  def check_club_limitation
    if self.new_clubs? && self.club_id
      errors.add(:base, 'Seurarajoitus ei voi olla voimassa samalla kun sallitaan uusien seurojen lisäys')
    end
  end

  def reset_club_id_for_full_rights
    self.club_id = nil unless only_add_competitors
  end
end