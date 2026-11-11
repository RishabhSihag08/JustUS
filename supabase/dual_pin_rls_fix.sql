-- =============================================================================
-- JustUS — Dual-PIN RLS & Storage Policy Fix for Supabase
-- Run this in your Supabase Project -> SQL Editor
--
-- Why this is needed:
-- The app uses secret 4-digit PIN authentication via the `verify_pin` RPC function.
-- Because users do not sign in with email/password Auth sessions, client queries
-- are executed under the `anon` role where `auth.uid()` evaluates to NULL.
-- The default policies required `auth.uid() = ...`, blocking all messages,
-- reactions, typing indicators, and media uploads with 42501 (RLS violation).
-- =============================================================================

-- 1. Ensure public and extensions are in search_path
SET search_path = public, extensions, pg_catalog;

-- 2. Drop restrictive policies that require Supabase Auth session (auth.uid())
DROP POLICY IF EXISTS "users_select_all" ON users;
DROP POLICY IF EXISTS "users_update_own" ON users;
DROP POLICY IF EXISTS "conversations_select_member" ON conversations;
DROP POLICY IF EXISTS "conversations_update_member" ON conversations;
DROP POLICY IF EXISTS "messages_select_member" ON messages;
DROP POLICY IF EXISTS "messages_insert_sender" ON messages;
DROP POLICY IF EXISTS "messages_update_sender" ON messages;
DROP POLICY IF EXISTS "messages_delete_sender" ON messages;
DROP POLICY IF EXISTS "reactions_select_member" ON reactions;
DROP POLICY IF EXISTS "reactions_insert_own" ON reactions;
DROP POLICY IF EXISTS "reactions_delete_own" ON reactions;
DROP POLICY IF EXISTS "starred_messages_select_own" ON starred_messages;
DROP POLICY IF EXISTS "starred_messages_insert_own" ON starred_messages;
DROP POLICY IF EXISTS "starred_messages_delete_own" ON starred_messages;
DROP POLICY IF EXISTS "typing_indicators_select_member" ON typing_indicators;
DROP POLICY IF EXISTS "typing_indicators_upsert_own" ON typing_indicators;
DROP POLICY IF EXISTS "media_uploads_select_member" ON media_uploads;
DROP POLICY IF EXISTS "media_uploads_insert_sender" ON media_uploads;
DROP POLICY IF EXISTS "media_uploads_update_sender" ON media_uploads;
DROP POLICY IF EXISTS "fcm_tokens_select_own" ON fcm_tokens;
DROP POLICY IF EXISTS "fcm_tokens_upsert_own" ON fcm_tokens;

-- 3. Create permissive policies for the anon role on all app tables
-- USERS
CREATE POLICY "anon_users_all" ON users
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- CONVERSATIONS
CREATE POLICY "anon_conversations_all" ON conversations
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- MESSAGES
CREATE POLICY "anon_messages_all" ON messages
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- REACTIONS
CREATE POLICY "anon_reactions_all" ON reactions
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- STARRED MESSAGES
CREATE POLICY "anon_starred_messages_all" ON starred_messages
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- TYPING INDICATORS
CREATE POLICY "anon_typing_indicators_all" ON typing_indicators
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- MEDIA UPLOADS
CREATE POLICY "anon_media_uploads_all" ON media_uploads
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- FCM TOKENS
CREATE POLICY "anon_fcm_tokens_all" ON fcm_tokens
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- 4. Enable Supabase Realtime for these tables
DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE messages;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE reactions;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE typing_indicators;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE users;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- 5. Storage bucket setup for 'chat-media'
INSERT INTO storage.buckets (id, name, public)
VALUES ('chat-media', 'chat-media', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Storage policies for chat-media bucket
DROP POLICY IF EXISTS "anon_storage_select" ON storage.objects;
DROP POLICY IF EXISTS "anon_storage_insert" ON storage.objects;
DROP POLICY IF EXISTS "anon_storage_update" ON storage.objects;
DROP POLICY IF EXISTS "anon_storage_delete" ON storage.objects;

CREATE POLICY "anon_storage_select" ON storage.objects
    FOR SELECT TO anon, authenticated
    USING (bucket_id = 'chat-media');

CREATE POLICY "anon_storage_insert" ON storage.objects
    FOR INSERT TO anon, authenticated
    WITH CHECK (bucket_id = 'chat-media');

CREATE POLICY "anon_storage_update" ON storage.objects
    FOR UPDATE TO anon, authenticated
    USING (bucket_id = 'chat-media')
    WITH CHECK (bucket_id = 'chat-media');

CREATE POLICY "anon_storage_delete" ON storage.objects
    FOR DELETE TO anon, authenticated
    USING (bucket_id = 'chat-media');
