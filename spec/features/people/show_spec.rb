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
    within('tr.person-row') do
      find('.view-button').click
    end
    wait_for_popup
  end

  scenario 'shows person data' do
    within(".modal-body #person_#{person.id}") do
      expect(page).to have_css 'p', text: person.email
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
