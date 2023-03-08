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
require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'Columns' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
    it { is_expected.to have_db_column(:color) }
    it { is_expected.to have_db_column(:is_for_sale) }
    it { is_expected.to have_db_column(:make) }
    it { is_expected.to have_db_column(:milage) }
    it { is_expected.to have_db_column(:model) }
    it { is_expected.to have_db_column(:owner_id) }

    it { is_expected.to have_db_index(:owner_id) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:ownerships).dependent(:nullify).order( purchased_at: :desc ) }
    it { is_expected.to belong_to(:owner).class_name('Person') }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:model) }
    it { is_expected.to validate_presence_of(:make) }
    it { is_expected.to validate_presence_of(:color) }
    it { is_expected.to validate_presence_of(:milage) }
    it { is_expected.to validate_presence_of(:owner_id) }
    it do
      is_expected.to validate_numericality_of(:milage)
        .is_greater_than_or_equal_to(0)
        .is_less_than(1_000_000)
    end

    it { is_expected.not_to allow_value(2_835_868_941).for(:milage) }
  end
end
