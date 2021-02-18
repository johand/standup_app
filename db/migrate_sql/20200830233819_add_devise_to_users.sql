ALTER TABLE "users" ADD "email" character varying DEFAULT '' NOT NULL;
ALTER TABLE "users" ADD "encrypted_password" character varying DEFAULT '' NOT NULL;
ALTER TABLE "users" ADD "reset_password_token" character varying;
ALTER TABLE "users" ADD "reset_password_sent_at" timestamp;
ALTER TABLE "users" ADD "remember_created_at" timestamp;
CREATE UNIQUE INDEX  "index_users_on_email" ON "users"  ("email");
CREATE UNIQUE INDEX  "index_users_on_reset_password_token" ON "users"  ("reset_password_token");
INSERT INTO schema_migrations (version) VALUES (20200830233819);
