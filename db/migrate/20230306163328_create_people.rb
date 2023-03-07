# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.string :phone

      t.index :email, unique: true

      t.timestamps
    end
  end
end
