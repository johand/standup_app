CREATE TABLE "integrations" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "account_id" uuid NOT NULL, "type" character varying, "settings" jsonb DEFAULT '{}' NOT NULL, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_63f87b241e"
FOREIGN KEY ("account_id")
  REFERENCES "accounts" ("id")
);
CREATE  INDEX  "index_integrations_on_account_id" ON "integrations"  ("account_id");
CREATE  INDEX  "index_integrations_on_settings" ON "integrations" USING gin ("settings");
INSERT INTO schema_migrations (version) VALUES (20210131222108);
