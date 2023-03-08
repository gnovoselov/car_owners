# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/index', type: :view do
  let!(:people) { create_list(:person, 2) }
  let(:row_selector) { '#people-table tbody tr[id]' }

  before do
    assign(:people, people)
    assign(:pagy, mock_pagy)
    render
  end

  it 'renders page title' do
    expect(rendered).to have_css 'h1.h2', text: 'People'
  end

  it 'renders table with people data and actions' do
    expect(rendered).to have_css row_selector, count: people.count
    expect(rendered).to have_css "#{row_selector} .view-button", count: people.count
    expect(rendered).to have_css "#{row_selector} .edit-button", count: people.count
    expect(rendered).to have_css "#{row_selector} .delete-button", count: people.count
  end

  it 'renders pagination' do
    expect(rendered).to have_css '.pagy-bootstrap-nav .pagination'
  end

  it 'renders new person button' do
    expect(rendered).to have_css '.add-new-button'
  end
end
