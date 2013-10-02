class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :raw_history, index: true, null: false
      t.string :from
      t.string :to
      t.string :price

      t.timestamps
    end
  end
end
