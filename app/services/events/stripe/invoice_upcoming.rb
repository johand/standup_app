# frozen_string_literal: true

module Events
  module Stripe
    class InvoiceUpcoming
      def call(event)
        ::Payments::InvoiceUpcoming.email(event.id).deliver_later
      end
    end
  end
end
