# frozen_string_literal: true

class StandupsController < ApplicationController
  before_action :set_standup, only: %i[show update destroy]

  # GET /standups
  # GET /standups.json
  def index
    redirect_to(root_path)
  end

  # GET /standups/1
  # GET /standups/1.json
  def show; end

  # GET /standups/new
  def new
    return if check_for_blank_date
    return if check_for_existance

    @standup = Standup.new
  end

  # GET /standups/1/edit
  def edit
    return if check_for_blank_date
    return if check_for_existance

    @standup = Standup.find_by(
      user_id: current_user.id,
      standup_date: current_date
    )
  end

  # POST /standups
  # POST /standups.json
  def create
    @standup = Standup.new(standup_params)
    @standup.user = current_user

    if @standup.save
      redirect_back(
        fallback_location: root_path,
        notice: 'Standup was successfully created.'
      )
    else
      render :new
    end
  end

  # PATCH/PUT /standups/1
  # PATCH/PUT /standups/1.json
  def update
    if @standup.update(standup_params)
      redirect_back(
        fallback_location: root_path,
        notice: 'Standup was successfully updated.'
      )
    end
  end

  # DELETE /standups/1
  # DELETE /standups/1.json
  def destroy
    @standup.destroy
    respond_to do |format|
      format.html { redirect_to standups_url, notice: 'Standup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_standup
    @standup = Standup.find(params[:id])
  end

  def check_for_blank_date
    if params[:date].blank?
      redirect_to(
        update_date_path(
          date: Date.today.iso8601,
          reload_path: "/s/#{action_name}/#{Date.today.iso8601}"
        )
      ) and return true
    end
  end

  def check_for_existance
    standup = Standup.find_by(
      user_id: current_user.id, standup_date: current_date
    )

    if standup.present? && action_name == 'new'
      redirect_to(edit_standup_path(date: current_date)) and return true
    elsif standup.nil? && action_name == 'edit'
      redirect_to(new_standup_path(date: current_date)) and return true
    end
  end

  # Only allow a list of trusted parameters through.
  def standup_params
    params.require(:standup).permit(:standup_date,
                                    dids_attributes: %i[id title _destroy],
                                    todos_attributes: %i[id title _destroy],
                                    blockers_attributes: %i[id title _destroy])
  end
end
