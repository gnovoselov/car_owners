# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TurboModalComponent, type: :component do
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }
  let(:close_button_selector) do
    'button.btn.btn-close[data-action="turbo-modal#hideModal"][data-bs-dismiss="modal"]'
  end
  let(:modal_content_selector) do
    '.modal-content[data-controller="turbo-modal"][data-action="turbo:submit-end->turbo-modal#submitEnd"]'
  end

  before(:each) do
    render_inline(described_class.new(title:)) { content }.css('p').to_html
  end

  it 'renders header' do
    expect(page).to have_css 'h1.fw-bold.mb-0.fs-2', text: title
  end

  it 'renders turbo modal content' do
    expect(page).to have_css '.modal-body.p-5.pt-0', text: content
  end

  it 'renders close button' do
    expect(page).to have_css close_button_selector
  end

  it 'binds controller to modal content' do
    expect(page).to have_css modal_content_selector
  end
end
