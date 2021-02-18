ALTER TABLE "users" ADD "provider" character varying;
ALTER TABLE "users" ADD "uid" character varying;
INSERT INTO schema_migrations (version) VALUES (20210205230902);
