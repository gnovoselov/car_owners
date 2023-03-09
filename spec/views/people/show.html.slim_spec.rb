# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/show', type: :view do
  let!(:person) { create(:person) }

  before do
    assign(:person, person)
    render
  end

  it 'renders person attributes' do
    expect(rendered).to have_css 'h1', text: person.name
    expect(rendered).to have_css "div[id=#{dom_id person}] .hstack", text: person.email
    expect(rendered).to have_css "div[id=#{dom_id person}] .hstack", text: number_to_phone(person.phone)
  end
end
