CREATE TABLE "accounts" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "name" character varying, "addr1" character varying, "addr2" character varying, "city" character varying, "state" character varying, "zip" character varying, "country" character varying, "settings" jsonb DEFAULT '{}' NOT NULL, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL);
CREATE  INDEX  "index_accounts_on_settings" ON "accounts" USING gin ("settings");
INSERT INTO schema_migrations (version) VALUES (20200903050257);
