class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :card, index: true, null: false
      t.text :raw_data
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
