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
      expect(page).to have_css '.hstack', text: car.color
      expect(page).to have_css '.hstack', text: car.owner.name
      expect(page).to have_css '.hstack', text: 'For sale' if car.is_for_sale
      expect(page).not_to have_css 'h6', text: 'Ownership history'
    end
  end

  context 'when a car had other owners in the past' do
    let!(:car) { create(:car, :with_ownership) }
    let(:ownership) { car.ownerships.first }
    let(:person) { ownership.person }

    scenario 'shows ownership history' do
      within(".modal-body #car_#{car.id}") do
        expect(page).to have_css 'h6', text: 'Ownership history'
        expect(page).to have_css 'h6.fw-bold', text: person.name
        expect(page).to have_css '.text-muted.fw-bold', text: ownership.purchased_at.strftime('%d %b %Y')
      end
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
