CREATE TABLE "events" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "type" character varying, "team_id" uuid NOT NULL, "user_name" character varying, "user_id" uuid NOT NULL, "event_name" character varying, "event_body" text, "event_id" character varying, "event_data" jsonb DEFAULT '{}', "event_time" timestamp, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_f62361cf64"
FOREIGN KEY ("team_id")
  REFERENCES "teams" ("id")
, CONSTRAINT "fk_rails_0cb5590091"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE  INDEX  "index_events_on_team_id" ON "events"  ("team_id");
CREATE  INDEX  "index_events_on_user_id" ON "events"  ("user_id");
CREATE  INDEX  "index_events_on_event_data" ON "events" USING gin ("event_data");
CREATE  INDEX  "index_events_on_type" ON "events"  ("type");
CREATE  INDEX  "index_events_on_user_name" ON "events"  ("user_name");
CREATE  INDEX  "index_events_on_event_id" ON "events"  ("event_id");
INSERT INTO schema_migrations (version) VALUES (20210207225403);
