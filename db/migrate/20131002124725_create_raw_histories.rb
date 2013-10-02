class CreateRawHistories < ActiveRecord::Migration
  def change
    create_table :raw_histories do |t|
      t.belongs_to :user, index: true, null: false
      t.text :data, null: false

      t.timestamps
    end
  end
end
