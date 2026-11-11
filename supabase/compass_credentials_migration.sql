-- =============================================================================
-- JustUS — Migration: Compass Credentials on Supabase (Plain text, no hashing)
-- Run this in your Supabase Project -> SQL Editor
-- =============================================================================

-- 1. Ensure public and extensions are in search path
SET search_path = public, extensions, pg_catalog;

-- 2. Add pin and compass_heading columns to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS pin TEXT DEFAULT '1234';
ALTER TABLE users ADD COLUMN IF NOT EXISTS compass_heading DOUBLE PRECISION DEFAULT 120.0;

-- 3. Seed/Update default values for User 1 and User 2
UPDATE users
SET pin = '1234',
    compass_heading = 120.0
WHERE role = 'user_1';

UPDATE users
SET pin = '5678',
    compass_heading = 260.0
WHERE role = 'user_2';

-- 4. Update verify_pin RPC function to support plain unhashed PINs
CREATE OR REPLACE FUNCTION verify_pin(p_pin TEXT)
RETURNS SETOF users
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, extensions, pg_catalog
AS $$
    SELECT * FROM users
    WHERE pin = p_pin OR pin_hash = p_pin OR pin_hash = extensions.crypt(p_pin, pin_hash)
    LIMIT 1;
$$;
