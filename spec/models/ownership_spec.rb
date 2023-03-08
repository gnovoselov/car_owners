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
require 'rails_helper'

RSpec.describe Ownership, type: :model do
  describe 'Columns' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
    it { is_expected.to have_db_column(:milage) }
    it { is_expected.to have_db_column(:price) }
    it { is_expected.to have_db_column(:purchased_at) }
    it { is_expected.to have_db_column(:car_id) }
    it { is_expected.to have_db_column(:person_id) }

    it { is_expected.to have_db_index(:car_id) }
    it { is_expected.to have_db_index(:person_id) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:person) }
    it { is_expected.to belong_to(:car) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:milage) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:purchased_at) }
    it { is_expected.to validate_presence_of(:car_id) }
    it { is_expected.to validate_presence_of(:person_id) }
    it do
      is_expected.to validate_numericality_of(:milage)
        .is_greater_than_or_equal_to(0)
        .is_less_than(1_000_000)
    end
    it { is_expected.to validate_comparison_of(:purchased_at).is_less_than_or_equal_to(Date.today) }

    it { is_expected.not_to allow_value(2_835_868_941).for(:milage) }
    it { is_expected.to allow_value(999_999).for(:milage) }
    it { is_expected.not_to allow_value(1.day.since).for(:purchased_at) }
    it { is_expected.to allow_value(Time.zone.now).for(:purchased_at) }
    it { is_expected.to allow_value(15.years.ago).for(:purchased_at) }
  end
end
