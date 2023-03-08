# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a car', type: :feature, js: true do
  let!(:owner) { create(:person) }
  let(:car_attributes) { attributes_for(:car) }
  let(:invalid_field_selector) { '.is-invalid' }
  let(:form_attributes) { car_attributes }
  let(:select_owner) { true }
  let(:wait_for_popup) do
    lambda do
      expect(page).to have_css 'h1', text: 'New Car'
    end
  end

  subject(:fill_form_and_submit) do
    for_sale = form_attributes.delete :is_for_sale
    fill_form_data form_attributes
    select owner.name, from: 'Owner' if select_owner
    check 'For sale' if for_sale
    click_on 'Create Car'
  end

  before do
    visit cars_path
    click_on 'Add new car'
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
      scenario 'shows created car' do
        within('#cars-table') do
          expect(page).to have_css 'td', text: "#{form_attributes[:make]} #{form_attributes[:model]}"
          expect(page).to have_css 'td', text: form_attributes[:color]
        end
      end
    end

    context 'and make is absent' do
      let(:form_attributes) { car_attributes.except(:make) }

      scenario 'shows error' do
        within('.field-make-container') do
          expect(page).to have_css "#{invalid_field_selector}#car_make"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and model is absent' do
      let(:form_attributes) { car_attributes.except(:model) }

      scenario 'shows error' do
        within('.field-model-container') do
          expect(page).to have_css "#{invalid_field_selector}#car_model"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and color is absent' do
      let(:form_attributes) { car_attributes.except(:color) }

      scenario 'shows error' do
        within('.field-color-container') do
          expect(page).to have_css "#{invalid_field_selector}#car_color"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and milage is absent' do
      let(:form_attributes) { car_attributes.except(:milage) }

      scenario 'shows error' do
        within('.field-milage-container') do
          expect(page).to have_css "#{invalid_field_selector}#car_milage"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end

    context 'and milage is invalid' do
      let(:car_attributes) { attributes_for(:car, :negative_milage) }

      scenario 'shows error' do
        within('.field-milage-container') do
          expect(page).to have_css "#{invalid_field_selector}#car_milage"
          expect(page).to have_css '.invalid-feedback', text: 'must be greater than or equal to 0'
        end
      end
    end

    context 'and owner is absent' do
      let(:select_owner) { false }

      scenario 'shows error' do
        within('.field-owner_id-container') do
          expect(page).to have_css "#{invalid_field_selector}#car_owner_id"
          expect(page).to have_css '.invalid-feedback', text: "can't be blank"
        end
      end
    end
  end
end
