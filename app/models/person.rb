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
class Person < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true,
                    email: { mode: :strict, require_fqdn: true },
                    uniqueness: { case_sensitive: false }
end
