# frozen_string_literal: true

module TeamEvents
  def set_events
    @events =
      @team
      .events
      .where(
        event_time: (
          current_date.to_time.beginning_of_day..current_date.to_time.end_of_day
        )
      )
      .includes(%i[user team])
      .order('event_time DESC')
  end
end
