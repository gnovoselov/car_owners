# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Page header', type: :feature do
  let(:current_path) { root_path }

  before { visit current_path }

  scenario 'shows user email' do
    within('.navigation-header') do
      expect(page).to have_css '.text-end span', text: @current_user.email
    end
  end

  scenario 'shows sign out button' do
    within('.navigation-header') do
      expect(page).to have_css '.text-end form.button_to[action="/users/sign_out"]', text: 'Sign out'
    end
  end

  scenario 'shows menu' do
    within('.navigation-header') do
      expect(page).to have_css '.nav-item a.text-white', text: 'People'
      expect(page).to have_css '.nav-item a.text-secondary', text: 'Cars'
    end
  end

  context 'when visiting cars page' do
    let(:current_path) { cars_path }

    scenario 'shows corresponding active menu item' do
      within('.navigation-header') do
        expect(page).to have_css '.nav-item a.text-secondary', text: 'People'
        expect(page).to have_css '.nav-item a.text-white', text: 'Cars'
      end
    end
  end
end
