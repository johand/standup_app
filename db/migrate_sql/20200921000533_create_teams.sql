CREATE TABLE "teams" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "name" character varying, "account_id" uuid NOT NULL, "timezone" character varying, "has_reminder" boolean, "has_recap" boolean, "reminder_time" time, "recap_time" time, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_b4ac0a83f9"
FOREIGN KEY ("account_id")
  REFERENCES "accounts" ("id")
);
CREATE  INDEX  "index_teams_on_account_id" ON "teams"  ("account_id");
CREATE  INDEX  "index_teams_on_has_reminder_and_reminder_time" ON "teams"  ("has_reminder", "reminder_time");
CREATE  INDEX  "index_teams_on_has_recap_and_recap_time" ON "teams"  ("has_recap", "recap_time");
INSERT INTO schema_migrations (version) VALUES (20200921000533);
