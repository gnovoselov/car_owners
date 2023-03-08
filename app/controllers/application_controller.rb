# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Turbo::FramesHelper if Rails.env.test?
  helper Turbo::StreamsHelper if Rails.env.test?

  include AppCollections
  include Pagy::Backend

  PER_PAGE = 20
  DEFAULT_PAGE = 1

  before_action :authenticate_user!

  protect_from_forgery with: :reset_session, prepend: true

  private

  def per_page
    PER_PAGE
  end

  def param_page
    params[:page] || DEFAULT_PAGE
  end

  def load_collection_paginated(collection)
    paginate_collection(collection, param_page)
  rescue Pagy::OverflowError
    page_number = param_page.to_i
    page = 1
    page = page_number - 1 if page_number > 1
    paginate_collection(collection, page)
  end

  def paginate_collection(collection, page)
    pagy(collection, items: per_page, page:)
  end
end
