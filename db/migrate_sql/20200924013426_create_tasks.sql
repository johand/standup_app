CREATE TABLE "tasks" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "type" character varying, "title" character varying, "is_completed" boolean, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL);
INSERT INTO schema_migrations (version) VALUES (20200924013426);
