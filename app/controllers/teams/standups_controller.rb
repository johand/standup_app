# frozen_string_literal: true

module Teams
  class StandupsController < ApplicationController
    include TeamEvents

    def index
      set_teams_and_standups(current_date)
      set_events
    end
  end
end
