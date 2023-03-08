# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Car data', type: :feature, js: true do
  let!(:car) { create(:car) }
  let(:wait_for_popup) do
    lambda do
      expect(page).to have_css 'h1', text: "#{car.make} #{car.model}"
    end
  end

  before do
    visit cars_path
    within('tr.car-row') do
      find('.view-button').click
    end
    wait_for_popup
  end

  scenario 'shows car data' do
    within(".modal-body #car_#{car.id}") do
      expect(page).to have_css 'p', text: car.color
      expect(page).to have_css 'p', text: car.owner.name
      expect(page).to have_css 'p', text: car.is_for_sale ? 'Yes' : 'No'
    end
  end

  context 'when closing form' do
    scenario 'does not show popup' do
      within('.modal-header') do
        find('.btn-close').click
      end
      expect(page).not_to have_css '.modal-content'
    end
  end
end
