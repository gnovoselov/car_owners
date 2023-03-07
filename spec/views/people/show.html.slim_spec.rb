# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/show', type: :view do
  before(:each) { assign(:person, create(:person)) }

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
  end
end
