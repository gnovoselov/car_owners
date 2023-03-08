# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cars/index', type: :view do
  let!(:cars) { create_list(:car, 2) }
  let(:row_selector) { '#cars-table tbody tr[id]' }

  before do
    assign(:cars, cars)
    assign(:pagy, mock_pagy)
    render
  end

  it 'renders page title' do
    expect(rendered).to have_css 'h1.h2', text: 'Cars'
  end

  it 'renders table with cars data and actions' do
    expect(rendered).to have_css row_selector, count: cars.count
    expect(rendered).to have_css "#{row_selector} .view-button", count: cars.count
    expect(rendered).to have_css "#{row_selector} .edit-button", count: cars.count
    expect(rendered).to have_css "#{row_selector} .delete-button", count: cars.count
  end

  it 'renders pagination' do
    expect(rendered).to have_css '.pagy-bootstrap-nav .pagination'
  end

  it 'renders new car button' do
    expect(rendered).to have_css '.add-new-button'
  end
end
