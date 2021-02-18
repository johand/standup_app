CREATE TABLE "days_of_the_week_memberships" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "team_id" uuid NOT NULL, "day" integer, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_65c64ea2d6"
FOREIGN KEY ("team_id")
  REFERENCES "teams" ("id")
);
CREATE  INDEX  "index_days_of_the_week_memberships_on_team_id" ON "days_of_the_week_memberships"  ("team_id");
INSERT INTO schema_migrations (version) VALUES (20200921011046);
