# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    Faker::Internet.email(name: "#{Faker::Name.name}#{n}")
  end
end
