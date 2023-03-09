# frozen_string_literal: true

class CreateOwnerships < ActiveRecord::Migration[7.0]
  def change
    create_table :ownerships do |t|
      t.date :purchased_at
      t.decimal :price
      t.integer :milage
      t.references :person, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true

      t.timestamps
    end
  end
end
