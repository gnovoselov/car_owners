# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a person', type: :feature, js: true do
  let(:person_attributes) { attributes_for(:person) }
  let(:invalid_field_selector) { '.is-invalid' }
  let(:form_attributes) { person_attributes }
  let(:wait_for_popup) do
    lambda do
      expect(page).to have_css 'h1', text: 'New Person'
    end
  end

  subject(:fill_form_and_submit) do
    fill_form_data form_attributes
    click_on 'Create Person'
  end

  before do
    visit people_path
    click_on 'Add new person'
    wait_for_popup
  end

  context 'when closing form' do
    scenario 'does not show popup' do
      within('.modal-header') do
        find('.btn-close').click
      end
      expect(page).not_to have_css '.modal-content'
    end
  end

  context 'when submitting form' do
    before { fill_form_and_submit }

    context 'and all parameters are valid' do
      scenario 'shows created person' do
        within('#people-table') do
          expect(page).to have_css 'td', text: form_attributes[:name]
          expect(page).to have_css 'td', text: form_attributes[:email]
        end
      end
    end

    context 'and phone is absent' do
      let(:form_attributes) { person_attributes.except(:phone) }

      scenario 'shows created person' do
        within('#people-table') do
          expect(page).to have_css 'td', text: form_attributes[:name]
          expect(page).to have_css 'td', text: form_attributes[:email]
        end
      end
    end

    context 'and name is absent' do
      let(:form_attributes) { person_attributes.except(:name) }

      scenario 'shows error' do
        within('.field-name-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_name"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and email is absent' do
      let(:form_attributes) { person_attributes.except(:email) }

      scenario 'shows error' do
        within('.field-email-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_email"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and email is taken' do
      let!(:person) { create(:person, email: form_attributes[:email]) }

      scenario 'shows error' do
        within('.field-email-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_email"
          expect(page).to have_css '.invalid-feedback', text: 'has already been taken'
        end
      end
    end

    context 'and email is invalid' do
      let(:person_attributes) { attributes_for(:person, :invalid_email) }

      scenario 'shows error' do
        within('.field-email-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_email"
          expect(page).to have_css '.invalid-feedback', text: 'is invalid'
        end
      end
    end
  end
end
