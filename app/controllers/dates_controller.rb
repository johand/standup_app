# frozen_string_literal: true

class DatesController < ApplicationController
  def update
    session[:current_date] = params[:date]

    if params[:reload_path]
      redirect_to(params[:reload_path])
    else
      redirect_back(fallback_location: root_path, turbolinks: true)
    end
  end
end
