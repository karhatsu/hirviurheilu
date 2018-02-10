class CreateDistricts < ActiveRecord::Migration[5.1]
  def up
    create_table :districts do |t|
      t.string :name, null: false
      t.string :short_name, null: false

      t.timestamps
    end
    unless Rails.env.test?
      districts = [
          ['Etelä-Häme', 'EH'],
          ['Kainuu', 'KA'],
          ['Keskipohja', 'KP'],
          ['Keski-Suomi', 'KS'],
          ['Kymi', 'KY'],
          ['Lappi', 'LA'],
          ['Oulu', 'OU'],
          ['Pohjanmaa', 'PO'],
          ['Pohjois-Häme', 'PH'],
          ['Pohjois-Karjala', 'PK'],
          ['Pohjois-Savo', 'PS'],
          ['Satakunta', 'SA'],
          ['Suur-Savo', 'SS'],
          ['Svenska Österbotten', 'SÖ'],
          ['Uusimaa', 'UM'],
          ['Varsinais-Suomi', 'VS'],
      ]
      districts.each do |district|
        District.create! name: district[0], short_name: district[1]
      end
    end
  end

  def down
    drop_table :districts
  end
end
