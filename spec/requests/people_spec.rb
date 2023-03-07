# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/people', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Person. As you add validations to Person, be sure to
  # adjust the attributes here as well.
  let(:described_model) { Person }
  let(:valid_attributes) { attributes_for(:person) }
  let(:invalid_attributes) { attributes_for(:person, :invalid_email) }

  describe 'GET /index' do
    let!(:person) { create(:person) }

    before { get people_url }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let!(:person) { create(:person) }

    before { get person_url(person) }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    before { get new_person_url }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let!(:person) { create(:person) }

    before { get edit_person_url(person) }

    it 'renders a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    subject(:post_person) do
      post people_url, params: { person: params }
    end

    context 'with valid parameters' do
      let(:params) { valid_attributes }

      it 'creates a new Person' do
        expect { post_person }.to change(described_model, :count).by(1)
      end

      context 'when the person is created' do
        before { post_person }

        it 'redirects to the created person' do
          expect(response).to redirect_to(person_url(described_model.last))
        end
      end
    end

    context 'with invalid parameters' do
      let(:params) { invalid_attributes }

      it 'does not create a new Person' do
        expect { post_person }.to change(Person, :count).by(0)
      end

      context 'after the create attempt' do
        before { post_person }

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /update' do
    let!(:person) { create(:person) }

    before do
      patch person_url(person), params: { person: params }
    end

    context 'with valid parameters' do
      let(:params) { valid_attributes }

      it 'updates the requested person' do
        person.reload
        expect(person.reload).to have_attributes(params)
      end

      it 'redirects to the person' do
        expect(response).to redirect_to(person_url(person))
      end
    end

    context 'with invalid parameters' do
      let(:params) { invalid_attributes }

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:person) { create(:person) }

    subject(:delete_person) do
      delete person_url(person)
    end

    it 'destroys the requested person' do
      expect { delete_person }.to change(Person, :count).by(-1)
    end

    context 'when the person is destroyed' do
      before { delete_person }

      it 'redirects to the people list' do
        expect(response).to redirect_to(people_url)
      end
    end
  end
end
