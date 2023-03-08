# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormHelper, type: :helper do
  let(:rendered_field) { content_tag(:input) }
  let(:form) do
    double(
      'form',
      text_field: rendered_field,
      object: double(
        'object',
        errors: double(
          'errors',
          '[]': %w[error1 error2]
        )
      )
    )
  end

  describe '.errors_for' do
    let(:field) { :field }

    subject { helper.errors_for(form, field) }

    it { is_expected.to include('div class="invalid-feedback"') }

    it 'renders first error for the field' do
      expect(strip_tags(subject)).to eq('error1')
    end
  end

  describe '.input_group_for' do
    let(:field) { :field }
    let(:options) { {} }

    subject { helper.input_group_for(form, field, options) }

    before do
      allow(helper).to receive(:errors_for).and_return('')
    end

    it { is_expected.to include('div class="input-group has-validation"') }

    it { is_expected.to include('span class="input-group-text"') }

    it 'renders the label' do
      expect(strip_tags(subject)).to eq(field.to_s.camelize)
    end

    it 'calls errors_for' do
      expect(helper).to receive(:errors_for).with(form, field)
      subject
    end

    context 'when there are no errors' do
      let(:form) do
        double(
          'form',
          text_field: rendered_field,
          object: double(
            'object',
            errors: double(
              'errors',
              '[]': []
            )
          )
        )
      end

      it 'does not call errors_for' do
        expect(helper).not_to receive(:errors_for)
        subject
      end

      it 'calls form_control_for with the right field type' do
        expect(form).to receive(:text_field).with(field, class: 'form-control ')
        subject
      end
    end

    context 'when type is passed' do
      let(:options) { { type: :check_box } }

      it 'calls form_control_for with the right field type' do
        expect(form).to receive(:check_box).with(field, class: 'form-control is-invalid')
        subject
      end
    end

    context 'when label is passed' do
      let(:options) { { label: 'SOME_LABEL_SUBSTITUTION' } }

      it 'renders the label' do
        expect(strip_tags(subject)).to eq('SOME_LABEL_SUBSTITUTION')
      end
    end
  end

  describe '.form_group_for' do
    let(:field) { :field }
    let(:options) { { some: :option } }
    let(:form) { double(:form, label: content_tag(:label, '', class: 'form-label')) }

    subject { helper.form_group_for(form, field, options) }

    before do
      allow(helper).to receive(:input_group_for).and_return('')
    end

    it { is_expected.to include(%Q{div class="field-#{field}-container col-12 mb-3"}) }

    it { is_expected.to include('label class="form-label"') }

    it 'calls input_group_for' do
      expect(helper).to receive(:input_group_for).with(form, field, options)
      subject
    end
  end
end
