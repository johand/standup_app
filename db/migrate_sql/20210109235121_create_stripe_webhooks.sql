CREATE TABLE "stripe_webhooks" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "stripe_event_id" character varying, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL);
CREATE  INDEX  "index_stripe_webhooks_on_stripe_event_id" ON "stripe_webhooks"  ("stripe_event_id");
INSERT INTO schema_migrations (version) VALUES (20210109235121);
