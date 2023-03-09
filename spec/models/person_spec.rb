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
require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'Columns' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
    it { is_expected.to have_db_column(:name) }
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:phone) }

    it { is_expected.to have_db_index(:email).unique(true) }
  end

  describe 'Associations' do
    it do
      is_expected.to have_many(:ownerships).inverse_of(:person)
                                           .dependent(:destroy)
                                           .order(purchased_at: :desc)
    end

    it do
      is_expected.to have_many(:cars).inverse_of(:owner)
                                     .with_foreign_key(:owner_id)
                                     .dependent(:nullify)
    end
  end

  describe 'Validations' do
    let(:valid_email) { generate(:email) }
    let(:invalid_email) { "#{valid_email}_invalid" }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value(valid_email).for(:email) }
    it { is_expected.not_to allow_value(invalid_email).for(:email) }
  end
end
