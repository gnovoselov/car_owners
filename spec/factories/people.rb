# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id         :bigint           not null, primary key
#  email      :string(255)
#  name       :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_people_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    email
    phone { Faker::PhoneNumber.phone_number }

    trait :invalid_email do
      email { "#{generate(:email)}_invalid" }
    end
  end
end
