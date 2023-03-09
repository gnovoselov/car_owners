# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def create_past_ownership(car, person, threshold)
  FactoryBot.create(
    :ownership,
    car:,
    person:,
    purchased_at: Faker::Date.between(from: 15.years.ago, to: threshold)
  )
end

100.times do
  # Generate a car and an owner
  car = FactoryBot.create(:car)
  person = car.owner
  current_ownership = FactoryBot.create(:ownership, car:, person:)

  # Let's say he could have several cars at once
  rand(0..3).times do
    another_car = FactoryBot.create(:car, owner: person)
    person.update(cars: person.cars + [another_car])
    create_past_ownership(another_car, person, current_ownership.purchased_at)
  end

  # And then he might have had other cars in the past
  # selecting from those in our database he never owned before
  rand(1..10).times do
    person_cars = person.ownerships.map(&:car_id)
    available_car = Car.where.not(id: person_cars).order(Arel.sql('RAND()')).first
    break unless available_car

    create_past_ownership(available_car, person, current_ownership.purchased_at)
  end
end
