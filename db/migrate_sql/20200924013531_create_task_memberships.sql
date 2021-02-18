CREATE TABLE "task_memberships" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "task_id" uuid NOT NULL, "standup_id" uuid NOT NULL, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL, CONSTRAINT "fk_rails_3d01931a83"
FOREIGN KEY ("task_id")
  REFERENCES "tasks" ("id")
, CONSTRAINT "fk_rails_2d26aab0b2"
FOREIGN KEY ("standup_id")
  REFERENCES "standups" ("id")
);
CREATE  INDEX  "index_task_memberships_on_task_id" ON "task_memberships"  ("task_id");
CREATE  INDEX  "index_task_memberships_on_standup_id" ON "task_memberships"  ("standup_id");
INSERT INTO schema_migrations (version) VALUES (20200924013531);
