# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Viewing people list', type: :feature do
  context 'when there are no people saved' do
    before { visit people_path }

    scenario 'shows that no people found' do
      within('#people-table') do
        expect(page).to have_content('No people found')
      end
    end
  end

  context 'when there are people in the DB' do
    let!(:people) { create_list(:person, 3) }

    before { visit people_path }

    scenario 'shows people table' do
      within('#people-table') do
        expect(page).to have_css 'tr.person-row', count: people.count
      end
    end
  end

  context 'when there are several pages' do
    let!(:people) { create_list(:person, 30) }
    let(:max_people_per_page) { ApplicationController::PER_PAGE }
    let(:page_item_selector) { 'li.page-item' }

    before { visit people_path }

    scenario 'shows people table' do
      within('#people-table') do
        expect(page).to have_css 'tr.person-row', count: max_people_per_page
      end
    end

    scenario 'shows pagination' do
      within('.pagination') do
        expect(page).to have_css "#{page_item_selector}.active", count: 1
        expect(page).to have_css "#{page_item_selector}.prev.disabled", count: 1
        expect(page).to have_css "#{page_item_selector}.next", count: 1
        expect(page).to have_css "#{page_item_selector} .page-link", count: (people.count / max_people_per_page) + 3
      end
    end
  end
end
