CREATE TABLE IF NOT EXISTS "migrations"(
  "id" integer primary key autoincrement not null,
  "migration" varchar not null,
  "batch" integer not null
);
CREATE TABLE IF NOT EXISTS "users"(
  "id" integer primary key autoincrement not null,
  "name" varchar not null,
  "email" varchar not null,
  "email_verified_at" datetime,
  "password" varchar not null,
  "remember_token" varchar,
  "created_at" datetime,
  "updated_at" datetime,
  "role" varchar check("role" in('customer', 'admin')) not null default 'customer'
);
CREATE UNIQUE INDEX "users_email_unique" on "users"("email");
CREATE TABLE IF NOT EXISTS "password_reset_tokens"(
  "email" varchar not null,
  "token" varchar not null,
  "created_at" datetime,
  primary key("email")
);
CREATE TABLE IF NOT EXISTS "sessions"(
  "id" varchar not null,
  "user_id" integer,
  "ip_address" varchar,
  "user_agent" text,
  "payload" text not null,
  "last_activity" integer not null,
  primary key("id")
);
CREATE INDEX "sessions_user_id_index" on "sessions"("user_id");
CREATE INDEX "sessions_last_activity_index" on "sessions"("last_activity");
CREATE TABLE IF NOT EXISTS "cache"(
  "key" varchar not null,
  "value" text not null,
  "expiration" integer not null,
  primary key("key")
);
CREATE TABLE IF NOT EXISTS "cache_locks"(
  "key" varchar not null,
  "owner" varchar not null,
  "expiration" integer not null,
  primary key("key")
);
CREATE TABLE IF NOT EXISTS "jobs"(
  "id" integer primary key autoincrement not null,
  "queue" varchar not null,
  "payload" text not null,
  "attempts" integer not null,
  "reserved_at" integer,
  "available_at" integer not null,
  "created_at" integer not null
);
CREATE INDEX "jobs_queue_index" on "jobs"("queue");
CREATE TABLE IF NOT EXISTS "job_batches"(
  "id" varchar not null,
  "name" varchar not null,
  "total_jobs" integer not null,
  "pending_jobs" integer not null,
  "failed_jobs" integer not null,
  "failed_job_ids" text not null,
  "options" text,
  "cancelled_at" integer,
  "created_at" integer not null,
  "finished_at" integer,
  primary key("id")
);
CREATE TABLE IF NOT EXISTS "failed_jobs"(
  "id" integer primary key autoincrement not null,
  "uuid" varchar not null,
  "connection" text not null,
  "queue" text not null,
  "payload" text not null,
  "exception" text not null,
  "failed_at" datetime not null default CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX "failed_jobs_uuid_unique" on "failed_jobs"("uuid");
CREATE TABLE IF NOT EXISTS "categories"(
  "id" integer primary key autoincrement not null,
  "name" varchar not null,
  "slug" varchar not null,
  "image" varchar,
  "parent_id" integer,
  "is_active" tinyint(1) not null default '1',
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("parent_id") references "categories"("id")
);
CREATE INDEX "categories_slug_index" on "categories"("slug");
CREATE UNIQUE INDEX "categories_slug_unique" on "categories"("slug");
CREATE TABLE IF NOT EXISTS "products"(
  "id" integer primary key autoincrement not null,
  "name" varchar not null,
  "description" text not null,
  "category_id" integer not null,
  "brand" varchar not null,
  "base_price" numeric not null,
  "is_featured" tinyint(1) not null default '0',
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("category_id") references "categories"("id")
);
CREATE TABLE IF NOT EXISTS "product_variants"(
  "id" integer primary key autoincrement not null,
  "product_id" integer not null,
  "size" varchar not null,
  "color" varchar not null,
  "sku" varchar not null,
  "price" numeric not null,
  "stock" integer not null,
  "weight" numeric,
  "is_available" tinyint(1) not null default '1',
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("product_id") references "products"("id")
);
CREATE UNIQUE INDEX "product_variants_sku_unique" on "product_variants"("sku");
CREATE TABLE IF NOT EXISTS "media"(
  "id" integer primary key autoincrement not null,
  "model_type" varchar not null,
  "model_id" integer not null,
  "file_path" varchar not null,
  "file_name" varchar not null,
  "mime_type" varchar not null,
  "alt_text" varchar,
  "created_at" datetime,
  "updated_at" datetime,
  "thumbnail_path" varchar,
  "medium_path" varchar,
  "large_path" varchar
);
CREATE INDEX "media_model_type_model_id_index" on "media"(
  "model_type",
  "model_id"
);
CREATE TABLE IF NOT EXISTS "orders"(
  "id" integer primary key autoincrement not null,
  "user_id" integer not null,
  "total_amount" numeric not null,
  "status" varchar check("status" in('pending', 'processing', 'shipped', 'delivered', 'cancelled')) not null,
  "shipping_address" text not null,
  "billing_address" text not null,
  "payment_method" varchar not null,
  "payment_status" varchar check("payment_status" in('pending', 'paid', 'failed', 'refunded')) not null,
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("user_id") references "users"("id")
);
CREATE TABLE IF NOT EXISTS "order_items"(
  "id" integer primary key autoincrement not null,
  "order_id" integer not null,
  "product_variant_id" integer not null,
  "quantity" integer not null,
  "price" numeric not null,
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("order_id") references "orders"("id"),
  foreign key("product_variant_id") references "product_variants"("id")
);
CREATE TABLE IF NOT EXISTS "coupons"(
  "id" integer primary key autoincrement not null,
  "code" varchar not null,
  "discount_type" varchar check("discount_type" in('fixed', 'percentage')) not null,
  "discount_value" numeric not null,
  "min_order_amount" numeric,
  "usage_limit" integer,
  "used_count" integer not null default '0',
  "expires_at" datetime,
  "is_active" tinyint(1) not null default '1',
  "created_at" datetime,
  "updated_at" datetime
);
CREATE UNIQUE INDEX "coupons_code_unique" on "coupons"("code");
CREATE TABLE IF NOT EXISTS "settings"(
  "id" integer primary key autoincrement not null,
  "key" varchar not null,
  "value" text not null,
  "type" varchar not null default 'string',
  "created_at" datetime,
  "updated_at" datetime
);
CREATE UNIQUE INDEX "settings_key_unique" on "settings"("key");
CREATE TABLE IF NOT EXISTS "carts"(
  "id" integer primary key autoincrement not null,
  "user_id" integer,
  "session_id" varchar,
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("user_id") references "users"("id")
);
CREATE INDEX "carts_session_id_index" on "carts"("session_id");
CREATE TABLE IF NOT EXISTS "cart_items"(
  "id" integer primary key autoincrement not null,
  "cart_id" integer not null,
  "product_variant_id" integer not null,
  "quantity" integer not null,
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("cart_id") references "carts"("id"),
  foreign key("product_variant_id") references "product_variants"("id")
);
CREATE TABLE IF NOT EXISTS "personal_access_tokens"(
  "id" integer primary key autoincrement not null,
  "tokenable_type" varchar not null,
  "tokenable_id" integer not null,
  "name" text not null,
  "token" varchar not null,
  "abilities" text,
  "last_used_at" datetime,
  "expires_at" datetime,
  "created_at" datetime,
  "updated_at" datetime
);
CREATE INDEX "personal_access_tokens_tokenable_type_tokenable_id_index" on "personal_access_tokens"(
  "tokenable_type",
  "tokenable_id"
);
CREATE UNIQUE INDEX "personal_access_tokens_token_unique" on "personal_access_tokens"(
  "token"
);
CREATE INDEX "personal_access_tokens_expires_at_index" on "personal_access_tokens"(
  "expires_at"
);
CREATE TABLE IF NOT EXISTS "refresh_tokens"(
  "id" integer primary key autoincrement not null,
  "token" varchar not null,
  "user_id" integer not null,
  "expires_at" datetime not null,
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("user_id") references "users"("id") on delete cascade
);
CREATE UNIQUE INDEX "refresh_tokens_token_unique" on "refresh_tokens"("token");
CREATE TABLE IF NOT EXISTS "notifications"(
  "id" integer primary key autoincrement not null,
  "created_at" datetime,
  "updated_at" datetime
);
CREATE TABLE IF NOT EXISTS "inventories"(
  "id" integer primary key autoincrement not null,
  "product_variant_id" integer not null,
  "quantity" integer not null default '0',
  "low_stock_threshold" integer not null default '10',
  "last_restocked_at" datetime,
  "status" varchar not null default 'in_stock',
  "created_at" datetime,
  "updated_at" datetime,
  foreign key("product_variant_id") references "product_variants"("id") on delete cascade
);

INSERT INTO migrations VALUES(1,'0001_01_01_000000_create_users_table',1);
INSERT INTO migrations VALUES(2,'0001_01_01_000001_create_cache_table',1);
INSERT INTO migrations VALUES(3,'0001_01_01_000002_create_jobs_table',1);
INSERT INTO migrations VALUES(4,'2026_01_11_194240_create_categories_table',1);
INSERT INTO migrations VALUES(5,'2026_01_11_194325_create_products_table',1);
INSERT INTO migrations VALUES(6,'2026_01_11_194603_create_product_variants_table',1);
INSERT INTO migrations VALUES(7,'2026_01_11_195037_create_media_table',1);
INSERT INTO migrations VALUES(8,'2026_01_11_195247_create_orders_table',1);
INSERT INTO migrations VALUES(9,'2026_01_11_195313_create_order_items_table',1);
INSERT INTO migrations VALUES(10,'2026_01_11_195649_create_coupons_table',1);
INSERT INTO migrations VALUES(11,'2026_01_11_195712_create_settings_table',1);
INSERT INTO migrations VALUES(12,'2026_01_11_195733_create_carts_table',1);
INSERT INTO migrations VALUES(13,'2026_01_11_195749_create_cart_items_table',1);
INSERT INTO migrations VALUES(14,'2026_01_11_195834_add_role_to_users_table',1);
INSERT INTO migrations VALUES(15,'2026_01_11_214455_create_personal_access_tokens_table',1);
INSERT INTO migrations VALUES(16,'2026_01_11_220857_create_refresh_tokens_table',1);
INSERT INTO migrations VALUES(17,'2026_01_12_125328_add_image_size_paths_to_media_table',1);
INSERT INTO migrations VALUES(18,'2026_01_12_232502_create_notifications_table',1);
INSERT INTO migrations VALUES(19,'2026_01_12_232700_create_inventories_table',1);
