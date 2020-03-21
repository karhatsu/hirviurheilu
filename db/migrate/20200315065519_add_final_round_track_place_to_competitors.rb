class AddFinalRoundTrackPlaceToCompetitors < ActiveRecord::Migration[6.0]
  def change
    rename_column :competitors, :track_place, :qualification_round_track_place
    add_column :competitors, :final_round_track_place, :integer
  end
end
