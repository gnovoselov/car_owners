# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Personal card', type: :feature, js: true do
  let!(:person) { create(:person) }
  let(:wait_for_popup) do
    lambda do
      expect(page).to have_css 'h1', text: person.name
    end
  end

  before do
    visit people_path
    within('tr.person-row:first-child') do
      find('.view-button').click
    end
    wait_for_popup
  end

  scenario 'shows person data' do
    within(".modal-body #person_#{person.id}") do
      expect(page).to have_css '.hstack', text: person.email
      expect(page).not_to have_css 'h6', text: 'Ownership history'
    end
  end

  context 'when a person has purchases in the past' do
    let!(:person) { create(:person, :with_ownership) }
    let(:ownership) { person.ownerships.first }
    let(:car) { ownership.car }

    scenario 'shows ownership history' do
      within(".modal-body #person_#{person.id}") do
        expect(page).to have_css 'h6', text: 'Ownership history'
        expect(page).to have_css 'h6.fw-bold', text: "#{car.make} #{car.model} (#{car.color})"
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
