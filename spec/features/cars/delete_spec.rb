# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting a car', type: :feature, js: true do
  let!(:cars) { create_list(:car, other_cars_amount) }
  let!(:car) { create(:car) }
  let(:other_cars_amount) { 1 }
  let(:params) { {} }

  before do
    visit cars_path(params)
    within("tr#car_#{car.id}") do
      find('.delete-button').click
    end
  end

  context 'when accepting confirmation' do
    before { accept_alert }

    scenario 'removes car data' do
      expect(page).not_to have_css "tr#car_#{car.id}"
    end

    context 'and removing last item' do
      let(:other_cars_amount) { 0 }

      scenario 'shows No cars message' do
        within('#cars-table') do
          expect(page).to have_content('No cars found')
        end
      end
    end

    context 'and removing last item on the page' do
      let(:other_cars_amount) { ApplicationController::PER_PAGE }
      let(:params) { { page: 2 } }

      scenario 'shows previous page' do
        expect(page).not_to have_css "tr#car_#{car.id}"
        within('#cars-table') do
          expect(page).to have_css 'tr.car-row', count: other_cars_amount
        end
      end
    end
  end

  context 'when rejecting confirmation' do
    before { dismiss_confirm }

    scenario 'does not remove car data' do
      expect(page).to have_css "tr#car_#{car.id}"
      within('#cars-table') do
        expect(page).to have_css 'td', text: "#{car.make} #{car.model}"
        expect(page).to have_css 'td', text: car.color
      end
    end
  end
end
