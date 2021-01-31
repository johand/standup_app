# frozen_string_literal: true

module Events
  module Stripe
    class InvoicePaymentFailed
      def call(event)
        ::Payments::InvoicePaymentFailed.email(event.id).deliver_later
      end
    end
  end
end
