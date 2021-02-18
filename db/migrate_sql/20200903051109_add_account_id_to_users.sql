ALTER TABLE "users" ADD "account_id" uuid;
CREATE  INDEX  "index_users_on_account_id" ON "users"  ("account_id");
ALTER TABLE "users" ADD CONSTRAINT "fk_rails_61ac11da2b"
FOREIGN KEY ("account_id")
  REFERENCES "accounts" ("id")
;
INSERT INTO schema_migrations (version) VALUES (20200903051109);
