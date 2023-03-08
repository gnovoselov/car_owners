# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]
  before_action :ensure_frame_response, only: %i[new edit show]

  # GET /people or /people.json
  def index
    @pagy, @people = load_all_people
  end

  # GET /people/1 or /people/1.json
  def show; end

  # GET /people/new
  def new
    @person = people_collection.new
  end

  # GET /people/1/edit
  def edit; end

  # POST /people or /people.json
  def create
    @person = people_collection.new(person_params)

    respond_to do |format|
      if @person.save
        render_saved_person(format, :created)
      else
        render_error(format, :new)
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        render_saved_person(format)
      else
        render_error(format, :edit)
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy

    respond_to do |format|
      format.turbo_stream { turbo_stream_replace_table }
      format.html { redirect_to people_url, notice: t('people.successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def load_all_people
    load_collection_paginated(people_collection.all)
  end

  def render_error(format, action)
    format.html { render action, status: :unprocessable_entity }
    format.json { render json: @person.errors, status: :unprocessable_entity }
  end

  def render_saved_person(format, status = :ok)
    format.turbo_stream { turbo_stream_replace_table }
    format.html { redirect_to person_url(@person), notice: t('people.successfully_saved') }
    format.json { render :show, status:, location: @person }
  end

  def turbo_stream_replace_table
    pagy, people = load_all_people
    render turbo_stream: turbo_stream.replace('people-table', partial: 'people/people_table',
                                                              locals: { people:, pagy: })
  end

  def set_person
    @person = people_collection.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :email, :phone)
  end

  def ensure_frame_response
    redirect_to root_path unless turbo_frame_request?
  end
end
