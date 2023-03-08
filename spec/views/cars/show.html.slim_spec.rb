# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cars/show', type: :view do
  let!(:car) { create(:car) }

  before do
    assign(:car, car)
    render
  end

  it 'renders car attributes' do
    expect(rendered).to have_css 'h1', text: "#{car.make} #{car.model}"
    expect(rendered).to have_css "div[id=#{dom_id car}] p", text: car.color
    expect(rendered).to have_css "div[id=#{dom_id car}] p", text: number_with_delimiter(car.milage, delimiter: ',')
    expect(rendered).to have_css "div[id=#{dom_id car}] p", text: car.owner.name
    expect(rendered).to have_css "div[id=#{dom_id car}] p", text: car.is_for_sale ? 'Yes' : 'No'
  end
end
