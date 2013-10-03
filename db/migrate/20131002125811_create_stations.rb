class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :area_code
      t.string :line_code
      t.string :station_code
      t.string :area_name
      t.string :line_name
      t.string :station_name

      t.timestamps
    end
  end
end
