# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting a person', type: :feature, js: true do
  let!(:people) { create_list(:person, other_people_amount) }
  let!(:person) { create(:person) }
  let(:other_people_amount) { 1 }
  let(:params) { {} }

  before do
    visit people_path(params)
    within("tr#person_#{person.id}") do
      find('.delete-button').click
    end
  end

  context 'when accepting confirmation' do
    before { accept_alert }

    scenario 'removes person data' do
      expect(page).not_to have_css "tr#person_#{person.id}"
    end

    context 'and removing last item' do
      let(:other_people_amount) { 0 }

      scenario 'shows No people message' do
        within('#people-table') do
          expect(page).to have_content('No people found')
        end
      end
    end

    context 'and removing last item on the page' do
      let(:other_people_amount) { ApplicationController::PER_PAGE }
      let(:params) { { page: 2 } }

      scenario 'shows previous page' do
        expect(page).not_to have_css "tr#person_#{person.id}"
        within('#people-table') do
          expect(page).to have_css 'tr.person-row', count: other_people_amount
        end
      end
    end
  end

  context 'when rejecting confirmation' do
    before { dismiss_confirm }

    scenario 'does not remove person data' do
      expect(page).to have_css "tr#person_#{person.id}"
      within('#people-table') do
        expect(page).to have_css 'td', text: person.name
        expect(page).to have_css 'td', text: person.email
      end
    end
  end
end
