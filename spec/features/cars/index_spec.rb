# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cars list', type: :feature do
  context 'when there are no cars saved' do
    before { visit cars_path }

    scenario 'shows that no cars found' do
      within('#cars-table') do
        expect(page).to have_content('No cars found')
      end
    end
  end

  context 'when there are cars in the DB' do
    let!(:cars) { create_list(:car, 3) }

    before { visit cars_path }

    scenario 'shows cars table' do
      within('#cars-table') do
        expect(page).to have_css 'tr.car-row', count: cars.count
      end
    end
  end

  context 'when there are several pages' do
    let!(:cars) { create_list(:car, 30) }
    let(:max_cars_per_page) { ApplicationController::PER_PAGE }
    let(:page_item_selector) { 'li.page-item' }

    before { visit cars_path }

    scenario 'shows cars table' do
      within('#cars-table') do
        expect(page).to have_css 'tr.car-row', count: max_cars_per_page
      end
    end

    scenario 'shows pagination' do
      within('.pagination') do
        expect(page).to have_css "#{page_item_selector}.active", count: 1
        expect(page).to have_css "#{page_item_selector}.prev.disabled", count: 1
        expect(page).to have_css "#{page_item_selector}.next", count: 1
        expect(page).to have_css "#{page_item_selector} .page-link", count: (cars.count / max_cars_per_page) + 3
      end
    end
  end
end
