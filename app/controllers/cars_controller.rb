# frozen_string_literal: true

class CarsController < ApplicationController
  before_action :set_car, only: %i[show edit update destroy]
  before_action :ensure_frame_response, only: %i[new edit show]

  # GET /cars or /cars.json
  def index
    @pagy, @cars = load_all_cars
  end

  # GET /cars/1 or /cars/1.json
  def show; end

  # GET /cars/new
  def new
    @car = cars_collection.new
  end

  # GET /cars/1/edit
  def edit; end

  # POST /cars or /cars.json
  def create
    @car = cars_collection.new(car_params)

    respond_to do |format|
      if @car.save
        render_saved_car(format, :created)
      else
        render_error(format, :new)
      end
    end
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        render_saved_car(format)
      else
        render_error(format, :edit)
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    @car.destroy

    respond_to do |format|
      format.turbo_stream { turbo_stream_replace_table }
      format.html { redirect_to cars_url, notice: t('cars.successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def load_all_cars
    load_collection_paginated(cars_collection.includes(:owner).order(sort_options).all)
  end

  def sort_options
    return { id: :asc } if params[:sort].blank?

    case params[:sort]
    when 'name'
      { make: sorting_direction, model: sorting_direction }
    when 'owner'
      { 'people.name' => sorting_direction }
    else
      { params[:sort] => sorting_direction }
    end
  end

  def render_error(format, action)
    format.html { render action, status: :unprocessable_entity }
    format.json { render json: @car.errors, status: :unprocessable_entity }
  end

  def render_saved_car(format, status = :ok)
    format.turbo_stream { turbo_stream_replace_table }
    format.html { redirect_to car_url(@car), notice: t('cars.successfully_saved') }
    format.json { render :show, status:, location: @car }
  end

  def turbo_stream_replace_table
    pagy, cars = load_all_cars
    render turbo_stream: turbo_stream.replace('cars-table', partial: 'cars/cars_table',
                                                            locals: { cars:, pagy: })
  end

  def set_car
    @car = cars_collection.includes(:ownerships, :owner).find(params[:id])
  end

  def car_params
    params.require(:car).permit(:model, :make, :color, :milage, :owner_id, :is_for_sale)
  end

  def ensure_frame_response
    redirect_to cars_path unless turbo_frame_request?
  end
end
