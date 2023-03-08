# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleHelper, type: :helper do
  let(:person) { create(:person) }

  describe '.owner_info_link' do
    let(:block) { proc { person.name } }

    subject { helper.owner_info_link(person) }

    before do
      allow(helper).to receive(:turbo_frame_button)
      subject
    end

    it 'renders a turbo frame button' do
      expect(helper).to have_received(:turbo_frame_button).with(person, 'view-owner-button', &block)
    end
  end
end
