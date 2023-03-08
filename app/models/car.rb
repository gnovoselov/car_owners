# frozen_string_literal: true

# == Schema Information
#
# Table name: cars
#
#  id          :bigint           not null, primary key
#  color       :string(255)
#  is_for_sale :boolean          default(FALSE), not null
#  make        :string(255)
#  milage      :integer
#  model       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#
# Indexes
#
#  index_cars_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => people.id)
#
class Car < ApplicationRecord
  belongs_to :owner, class_name: 'Person'

  validates :model, :make, :color, :milage, :owner_id, presence: true
  validates :milage, numericality: { greater_than_or_equal_to: 0, less_than: 1_000_000 }
end
