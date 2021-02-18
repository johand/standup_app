CREATE TABLE "team_memberships" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "team_id" uuid NOT NULL, "user_id" uuid NOT NULL, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_61c29b529e"
FOREIGN KEY ("team_id")
  REFERENCES "teams" ("id")
, CONSTRAINT "fk_rails_5aba9331a7"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE  INDEX  "index_team_memberships_on_team_id" ON "team_memberships"  ("team_id");
CREATE  INDEX  "index_team_memberships_on_user_id" ON "team_memberships"  ("user_id");
INSERT INTO schema_migrations (version) VALUES (20200921001305);
