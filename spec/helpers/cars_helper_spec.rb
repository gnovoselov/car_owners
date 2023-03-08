# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarsHelper, type: :helper do
  let(:car) { build(:car, is_for_sale: for_sale) }
  let(:for_sale) { false }

  describe '.car_info_link' do
    let(:block) { proc { "#{car.make} #{car.model}" } }

    subject { helper.car_info_link(car) }

    before do
      allow(helper).to receive(:turbo_frame_button)
      subject
    end

    it 'renders a turbo frame button' do
      expect(helper).to have_received(:turbo_frame_button).with(car, 'view-car-button', &block)
    end

    context 'when car is nil' do
      let(:car) { nil }

      it { is_expected.to eq('') }
    end
  end

  describe '.car_full_name' do
    subject { helper.car_full_name(car) }

    it { is_expected.to eq("#{car.make} #{car.model}") }

    context 'when car is nil' do
      let(:car) { nil }

      it { is_expected.to eq('') }
    end
  end

  describe '.owner_class' do
    subject { helper.owner_class(car) }

    it { is_expected.to eq(Person) }
  end

  describe '.car_for_sale' do
    subject { helper.car_for_sale(car) }

    before do
      allow(helper).to receive(:yes_icon)
      allow(helper).to receive(:no_icon)
    end

    it 'calls no_icon' do
      expect(helper).to receive(:no_icon)
      subject
    end

    context 'when car is for sale' do
      let(:for_sale) { true }

      it 'calls yes_icon' do
        expect(helper).to receive(:yes_icon)
        subject
      end
    end
  end

  describe '.owners_for_select' do
    let!(:person) { create(:person) }
    let(:people_collection) { Person }
    let(:build_options) do
      [
        [t('select_one'), ''],
        [person.name, person.id]
      ]
    end

    subject { helper.owners_for_select(car, people_collection) }

    before { allow(helper).to receive(:options_for_select) }

    it 'calls options_for_select' do
      expect(helper).to receive(:options_for_select).with(build_options, car.owner_id)
      subject
    end
  end

  describe '.yes_icon' do
    subject { helper.yes_icon }

    before { allow(helper).to receive(:bootstrap_icon) }

    it 'calls bootstrap_icon' do
      expect(helper).to receive(:bootstrap_icon).with('check2', width: 15, height: 15, class: 'text-success')
      subject
    end
  end

  describe '.no_icon' do
    subject { helper.no_icon }

    before { allow(helper).to receive(:bootstrap_icon) }

    it 'calls bootstrap_icon' do
      expect(helper).to receive(:bootstrap_icon).with('x', width: 15, height: 15, class: 'text-danger')
      subject
    end
  end
end
