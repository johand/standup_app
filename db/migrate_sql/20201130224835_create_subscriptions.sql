CREATE TABLE "subscriptions" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "account_id" uuid NOT NULL, "plan_id" character varying, "stripe_customer_id" character varying, "start" timestamp, "status" character varying, "stripe_subscription_id" character varying, "stripe_token" character varying, "card_last4" character varying, "card_expiration" character varying, "card_type" character varying, "stripe_status" character varying, "idempotency_key" character varying, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_eb0e3ffd90"
FOREIGN KEY ("account_id")
  REFERENCES "accounts" ("id")
);
CREATE  INDEX  "index_subscriptions_on_account_id" ON "subscriptions"  ("account_id");
INSERT INTO schema_migrations (version) VALUES (20201130224835);
