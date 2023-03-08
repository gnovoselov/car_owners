# frozen_string_literal: true

class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :model
      t.string :make
      t.string :color
      t.integer :milage
      t.references :owner, null: false, foreign_key: { to_table: :people }
      t.boolean :is_for_sale, null: false, default: false

      t.timestamps
    end
  end
end
