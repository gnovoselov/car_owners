# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '.active_class' do
    let(:link_path) { 'link_path' }
    let(:current_path) { true }

    subject { helper.active_class(link_path) }

    before do
      allow(helper).to receive(:current_page?).and_return(current_path)
    end

    it 'returns text class' do
      expect(subject).to eq('text-white')
    end

    context 'when current page is not the link path' do
      let(:current_path) { false }

      it 'returns text class' do
        expect(subject).to eq('text-secondary')
      end
    end
  end

  describe '.turbo_frame_button' do
    let(:target) { 'target' }
    let(:class_name) { 'SOME_CLASS_NAME' }
    let(:block) { proc { 'block' } }
    let(:data_params) do
      {
        turbo_frame: 'modal',
        bs_toggle: 'modal',
        bs_target: '#modalDialog'
      }
    end

    subject { helper.turbo_frame_button(target, class_name, &block) }

    before do
      allow(helper).to receive(:button_to)
      subject
    end

    it 'calls button_to' do
      expect(helper).to have_received(:button_to).with(
        target,
        {
          method: :get,
          class: "#{class_name} btn btn-link p-0",
          data: data_params
        },
        &block
      )
    end
  end
end
