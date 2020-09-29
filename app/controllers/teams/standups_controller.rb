# frozen_string_literal: true

module Teams
  class StandupsController < ApplicationController
    def index
      set_teams_and_standups(current_date)
    end
  end
end
