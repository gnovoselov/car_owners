# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'cars/show', type: :view do
  let!(:car) { create(:car, is_for_sale:) }
  let(:is_for_sale) { true }

  before do
    assign(:car, car)
    render
  end

  it 'renders car attributes' do
    expect(rendered).to have_css 'h1', text: "#{car.make} #{car.model}"
    expect(rendered).to have_css "div[id=#{dom_id car}] .hstack", text: car.color
    expect(rendered).to have_css "div[id=#{dom_id car}] .hstack",
                                 text: number_with_delimiter(car.milage, delimiter: ',')
    expect(rendered).to have_css "div[id=#{dom_id car}] .hstack", text: car.owner.name
    expect(rendered).to have_css "div[id=#{dom_id car}] .hstack", text: 'For sale'
  end

  context 'when car is not for sale' do
    let(:is_for_sale) { false }

    it 'renders car attributes' do
      expect(rendered).not_to have_css "div[id=#{dom_id car}] .hstack", text: 'For sale'
    end
  end
end
