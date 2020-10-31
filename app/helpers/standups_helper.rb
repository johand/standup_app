# frozen_string_literal: true

module StandupsHelper
  def notification_standups(user)
    user.teams.flat_map do |t|
      t.users.flat_map do |u|
        u.standups
         .includes(%i[task_memberships dids todos blockers])
         .order(created_at: :desc).limit(10)
      end
    end
        .sort_by(&:created_at)
        .reverse[0..9]
  end
end
