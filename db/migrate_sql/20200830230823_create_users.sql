CREATE TABLE "users" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "name" character varying, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL);
INSERT INTO schema_migrations (version) VALUES (20200830230823);
