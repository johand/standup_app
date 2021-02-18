CREATE TABLE "standups" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "user_id" uuid NOT NULL, "standup_date" date, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_7d8ef7c268"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE  INDEX  "index_standups_on_user_id" ON "standups"  ("user_id");
INSERT INTO schema_migrations (version) VALUES (20200919223317);
