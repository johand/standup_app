ALTER TABLE "teams" ADD "integration_settings" jsonb DEFAULT '{}' NOT NULL;
CREATE  INDEX  "index_teams_on_integration_settings" ON "teams" USING gin ("integration_settings");
INSERT INTO schema_migrations (version) VALUES (20210202223235);
