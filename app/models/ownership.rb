# frozen_string_literal: true

# == Schema Information
#
# Table name: ownerships
#
#  id           :bigint           not null, primary key
#  milage       :integer
#  price        :decimal(10, )
#  purchased_at :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  car_id       :bigint           not null
#  person_id    :bigint           not null
#
# Indexes
#
#  index_ownerships_on_car_id     (car_id)
#  index_ownerships_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (car_id => cars.id)
#  fk_rails_...  (person_id => people.id)
#
class Ownership < ApplicationRecord
  belongs_to :person
  belongs_to :car

  validates :purchased_at, :price, :milage, :person_id, :car_id, presence: true
  validates :purchased_at, comparison: { less_than_or_equal_to: Time.zone.today }
  validates :milage, numericality: { greater_than_or_equal_to: 0, less_than: 1_000_000 }
end
