CREATE TABLE "roles" ("id" uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, "name" character varying, "resource_type" character varying, "resource_id" uuid, "created_at" timestamp(6) NOT NULL, "updated_at" timestamp(6) NOT NULL);
CREATE  INDEX  "index_roles_on_resource_type_and_resource_id" ON "roles"  ("resource_type", "resource_id");
CREATE TABLE "users_roles" ("user_id" uuid, "role_id" uuid);
CREATE  INDEX  "index_users_roles_on_user_id" ON "users_roles"  ("user_id");
CREATE  INDEX  "index_users_roles_on_role_id" ON "users_roles"  ("role_id");
CREATE  INDEX  "index_roles_on_name_and_resource_type_and_resource_id" ON "roles"  ("name", "resource_type", "resource_id");
CREATE  INDEX  "index_users_roles_on_user_id_and_role_id" ON "users_roles"  ("user_id", "role_id");
INSERT INTO schema_migrations (version) VALUES (20200913043459);
