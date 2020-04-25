class AddFinishedToSeries < ActiveRecord::Migration[6.0]
  def up
    add_column :series, :finished, :boolean, default: false, null: false
    execute "update series s set finished = true from races r where s.race_id = r.id and r.finished = true and r.sport_key not in ('RUN', 'SKI')"
  end

  def down
    remove_column :series, :finished
  end
end
