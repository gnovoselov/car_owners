# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Updating a person', type: :feature, js: true do
  let!(:person) { create(:person) }
  let(:invalid_field_selector) { '.is-invalid' }
  let(:wait_for_popup) do
    lambda do
      expect(page).to have_css 'h1', text: 'Edit Person'
    end
  end

  subject(:fill_form_and_submit) do
    fill_form_data form_attributes
    click_on 'Update Person'
  end

  before do
    visit people_path
    within('tr.person-row') do
      find('.edit-button').click
    end
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
      let(:form_attributes) { attributes_for(:person) }

      scenario 'shows updated person' do
        within('#people-table') do
          expect(page).to have_css 'td', text: form_attributes[:name]
          expect(page).to have_css 'td', text: form_attributes[:email]
        end
      end
    end

    context 'and phone is absent' do
      let(:form_attributes) { { phone: '' } }

      scenario 'shows created person' do
        within('#people-table') do
          expect(page).to have_css 'td', text: form_attributes[:name]
          expect(page).to have_css 'td', text: form_attributes[:email]
        end
      end
    end

    context 'and name is absent' do
      let(:form_attributes) { { name: '' } }

      scenario 'shows created person' do
        within('.field-name-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_name"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and email is absent' do
      let(:form_attributes) { { email: '' } }

      scenario 'shows created person' do
        within('.field-email-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_email"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and email is taken' do
      let!(:another_person) { create(:person) }
      let(:form_attributes) { { email: another_person.email } }

      scenario 'shows created person' do
        within('.field-email-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_email"
          expect(page).to have_css '.invalid-feedback', text: 'has already been taken'
        end
      end
    end

    context 'and email is invalid' do
      let(:form_attributes) { attributes_for(:person, :invalid_email).slice(:email) }

      scenario 'shows created person' do
        within('.field-email-container') do
          expect(page).to have_css "#{invalid_field_selector}#person_email"
          expect(page).to have_css '.invalid-feedback', text: 'is invalid'
        end
      end
    end
  end
end
