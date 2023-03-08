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
FactoryBot.define do
  factory :ownership do
    purchased_at { Faker::Date.backward(years: 15) }
    price { Faker::Commerce.price(range: 100..1_000_000) }
    milage { Faker::Vehicle.mileage }
    person
    car
  end
end
