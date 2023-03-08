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
FactoryBot.define do
  factory :car do
    make { Faker::Vehicle.make }
    model { Faker::Vehicle.model(make_of_model: make) }
    color { Faker::Vehicle.color }
    milage { Faker::Vehicle.mileage }
    association :owner, factory: :person
    is_for_sale { Faker::Boolean.boolean }

    trait :negative_milage do
      milage { -1 }
    end
  end
end
