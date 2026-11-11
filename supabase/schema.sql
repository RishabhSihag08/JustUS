-- =============================================================================
-- JustUS — Supabase Schema for Private 2-Person Dual-PIN Chat App
-- Run this entire file in the Supabase SQL Editor BEFORE writing any Dart code.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Extensions
-- -----------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "pg_trgm" WITH SCHEMA extensions;

-- Ensure public and extensions functions (crypt, gen_salt, etc.) are in search path
SET search_path = public, extensions, pg_catalog;

-- -----------------------------------------------------------------------------
-- ENUM Types
-- -----------------------------------------------------------------------------
DO $$ BEGIN
    CREATE TYPE message_status AS ENUM ('pending', 'sent', 'delivered', 'read');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE message_type AS ENUM ('text', 'image', 'video', 'voice', 'document', 'view_once');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('user_1', 'user_2');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- -----------------------------------------------------------------------------
-- USERS Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role user_role NOT NULL UNIQUE,
    pin_hash TEXT NOT NULL,                     -- bcrypt hash (cost 12)
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    fcm_token TEXT,
    last_seen_at TIMESTAMPTZ,
    is_online BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed 2 users with genuine pgcrypto bcrypt hashes (cost 12)
-- PIN for User 1: 1234
-- PIN for User 2: 5678
INSERT INTO users (role, pin_hash, display_name, avatar_url) VALUES
    ('user_1', extensions.crypt('1234', extensions.gen_salt('bf', 12)), 'User One', NULL),
    ('user_2', extensions.crypt('5678', extensions.gen_salt('bf', 12)), 'User Two', NULL)
ON CONFLICT (role) DO NOTHING;

-- -----------------------------------------------------------------------------
-- CONVERSATIONS Table (single row, 1-on-1)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_1_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_2_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    disappearing_timer INTERVAL,                -- NULL = off, '24 hours', '7 days'
    view_once_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (user_1_id, user_2_id),
    CONSTRAINT conversations_distinct_users CHECK (user_1_id <> user_2_id)
);

-- Seed the single conversation row
INSERT INTO conversations (user_1_id, user_2_id)
SELECT u1.id, u2.id
FROM users u1
CROSS JOIN users u2
WHERE u1.role = 'user_1' AND u2.role = 'user_2'
ON CONFLICT (user_1_id, user_2_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- MESSAGES Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type message_type NOT NULL DEFAULT 'text',
    content TEXT,
    media_url TEXT,
    media_thumbnail_url TEXT,
    media_duration INT,                         -- milliseconds for voice/video
    media_size BIGINT,                          -- bytes
    media_mime_type TEXT,
    reply_to_id UUID REFERENCES messages(id) ON DELETE SET NULL,
    status message_status NOT NULL DEFAULT 'pending',
    is_starred BOOLEAN DEFAULT FALSE,
    is_disappearing BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMPTZ,                     -- for disappearing messages
    view_once_viewed BOOLEAN DEFAULT FALSE,
    view_once_viewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    delivered_at TIMESTAMPTZ,
    read_at TIMESTAMPTZ,
    search_vector TSVECTOR GENERATED ALWAYS AS (
        to_tsvector('english', COALESCE(content, ''))
    ) STORED
);

-- -----------------------------------------------------------------------------
-- REACTIONS Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reactions (
    message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    emoji TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (message_id, user_id, emoji)
);

-- -----------------------------------------------------------------------------
-- STARRED_MESSAGES Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS starred_messages (
    message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (message_id, user_id)
);

-- -----------------------------------------------------------------------------
-- TYPING_INDICATORS Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS typing_indicators (
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    is_typing BOOLEAN DEFAULT FALSE,
    is_recording BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (conversation_id, user_id)
);

-- -----------------------------------------------------------------------------
-- MEDIA_UPLOADS Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS media_uploads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    bucket_path TEXT NOT NULL,
    upload_status TEXT NOT NULL DEFAULT 'pending'
        CHECK (upload_status IN ('pending', 'uploading', 'completed', 'failed')),
    retry_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- FCM_TOKENS Table (multi-device + dual-user safe)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS fcm_tokens (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    device_id TEXT NOT NULL,
    platform TEXT NOT NULL CHECK (platform IN ('android', 'ios', 'web')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, device_id)
);

-- -----------------------------------------------------------------------------
-- INDEXES
-- -----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_messages_conversation_created ON messages (conversation_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_sender ON messages (sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_status ON messages (status);
CREATE INDEX IF NOT EXISTS idx_messages_reply_to ON messages (reply_to_id);
CREATE INDEX IF NOT EXISTS idx_messages_expires_at ON messages (expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_messages_view_once ON messages (id) WHERE type = 'view_once' AND view_once_viewed = FALSE;
CREATE INDEX IF NOT EXISTS idx_messages_search ON messages USING GIN (search_vector);

CREATE INDEX IF NOT EXISTS idx_reactions_message ON reactions (message_id);
CREATE INDEX IF NOT EXISTS idx_starred_messages_user ON starred_messages (user_id);
CREATE INDEX IF NOT EXISTS idx_typing_conversation ON typing_indicators (conversation_id);
CREATE INDEX IF NOT EXISTS idx_media_uploads_status ON media_uploads (upload_status);

-- -----------------------------------------------------------------------------
-- ROW LEVEL SECURITY (RLS)
-- -----------------------------------------------------------------------------
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE starred_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE typing_indicators ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_uploads ENABLE ROW LEVEL SECURITY;
ALTER TABLE fcm_tokens ENABLE ROW LEVEL SECURITY;

-- USERS: authenticated users can SELECT both rows; can UPDATE only their own row
CREATE POLICY "users_select_all" ON users
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "users_update_own" ON users
    FOR UPDATE USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- CONVERSATIONS: members can SELECT and UPDATE conversation settings
CREATE POLICY "conversations_select_member" ON conversations
    FOR SELECT USING (
        auth.uid() = user_1_id OR auth.uid() = user_2_id
    );

CREATE POLICY "conversations_update_member" ON conversations
    FOR UPDATE USING (
        auth.uid() = user_1_id OR auth.uid() = user_2_id
    )
    WITH CHECK (
        auth.uid() = user_1_id OR auth.uid() = user_2_id
    );

-- MESSAGES: sender can INSERT/UPDATE/DELETE their own messages; both users can SELECT
CREATE POLICY "messages_select_member" ON messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM conversations c
            WHERE c.id = messages.conversation_id
              AND (c.user_1_id = auth.uid() OR c.user_2_id = auth.uid())
        )
    );

CREATE POLICY "messages_insert_sender" ON messages
    FOR INSERT WITH CHECK (
        sender_id = auth.uid()
        AND EXISTS (
            SELECT 1 FROM conversations c
            WHERE c.id = messages.conversation_id
              AND (c.user_1_id = auth.uid() OR c.user_2_id = auth.uid())
        )
    );

CREATE POLICY "messages_update_sender" ON messages
    FOR UPDATE USING (sender_id = auth.uid())
    WITH CHECK (sender_id = auth.uid());

CREATE POLICY "messages_delete_sender" ON messages
    FOR DELETE USING (sender_id = auth.uid());

-- REACTIONS: users can INSERT/DELETE their own reactions; both can SELECT
CREATE POLICY "reactions_select_member" ON reactions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM messages m
            JOIN conversations c ON c.id = m.conversation_id
            WHERE m.id = reactions.message_id
              AND (c.user_1_id = auth.uid() OR c.user_2_id = auth.uid())
        )
    );

CREATE POLICY "reactions_insert_own" ON reactions
    FOR INSERT WITH CHECK (
        user_id = auth.uid()
        AND EXISTS (
            SELECT 1 FROM messages m
            JOIN conversations c ON c.id = m.conversation_id
            WHERE m.id = reactions.message_id
              AND (c.user_1_id = auth.uid() OR c.user_2_id = auth.uid())
        )
    );

CREATE POLICY "reactions_delete_own" ON reactions
    FOR DELETE USING (user_id = auth.uid());

-- STARRED_MESSAGES: users can manage only their own starred set
CREATE POLICY "starred_select_own" ON starred_messages
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "starred_insert_own" ON starred_messages
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "starred_delete_own" ON starred_messages
    FOR DELETE USING (user_id = auth.uid());

-- TYPING_INDICATORS: users can INSERT/UPDATE their own row; both can SELECT
CREATE POLICY "typing_select_member" ON typing_indicators
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM conversations c
            WHERE c.id = typing_indicators.conversation_id
              AND (c.user_1_id = auth.uid() OR c.user_2_id = auth.uid())
        )
    );

CREATE POLICY "typing_upsert_own" ON typing_indicators
    FOR INSERT WITH CHECK (
        user_id = auth.uid()
        AND EXISTS (
            SELECT 1 FROM conversations c
            WHERE c.id = typing_indicators.conversation_id
              AND (c.user_1_id = auth.uid() OR c.user_2_id = auth.uid())
        )
    );

CREATE POLICY "typing_update_own" ON typing_indicators
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- FCM_TOKENS: users can manage only their own token rows
CREATE POLICY "fcm_select_own" ON fcm_tokens
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "fcm_upsert_own" ON fcm_tokens
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "fcm_update_own" ON fcm_tokens
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "fcm_delete_own" ON fcm_tokens
    FOR DELETE USING (user_id = auth.uid());

-- MEDIA_UPLOADS: sender can manage their own uploads
CREATE POLICY "media_uploads_select_own" ON media_uploads
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "media_uploads_insert_own" ON media_uploads
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "media_uploads_update_own" ON media_uploads
    FOR UPDATE USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "media_uploads_delete_own" ON media_uploads
    FOR DELETE USING (user_id = auth.uid());

-- -----------------------------------------------------------------------------
-- REALTIME PUBLICATIONS & REPLICA IDENTITY
-- -----------------------------------------------------------------------------
-- Full replica identity ensures UPDATE/DELETE events include all columns in Realtime
ALTER TABLE messages REPLICA IDENTITY FULL;
ALTER TABLE reactions REPLICA IDENTITY FULL;
ALTER TABLE typing_indicators REPLICA IDENTITY FULL;
ALTER TABLE conversations REPLICA IDENTITY FULL;
ALTER TABLE users REPLICA IDENTITY FULL;

ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE reactions;
ALTER PUBLICATION supabase_realtime ADD TABLE typing_indicators;
ALTER PUBLICATION supabase_realtime ADD TABLE conversations;
ALTER PUBLICATION supabase_realtime ADD TABLE users;

-- -----------------------------------------------------------------------------
-- STORAGE BUCKET & POLICIES
-- -----------------------------------------------------------------------------
INSERT INTO storage.buckets (id, name, public)
VALUES ('chat-media', 'chat-media', false)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "chat_media_upload" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'chat-media'
        AND auth.role() = 'authenticated'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "chat_media_read" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'chat-media'
        AND auth.role() = 'authenticated'
    );

CREATE POLICY "chat_media_delete" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'chat-media'
        AND auth.role() = 'authenticated'
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- -----------------------------------------------------------------------------
-- SQL FUNCTIONS & TRIGGERS
-- -----------------------------------------------------------------------------

-- 1. verify_pin(p_pin TEXT) — returns matching user row using pgcrypto crypt()
CREATE OR REPLACE FUNCTION verify_pin(p_pin TEXT)
RETURNS SETOF users
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, extensions, pg_catalog
AS $$
    SELECT * FROM users
    WHERE pin_hash = extensions.crypt(p_pin, pin_hash)
    LIMIT 1;
$$;

-- 2. mark_messages_delivered(p_conversation_id UUID, p_recipient_id UUID)
CREATE OR REPLACE FUNCTION mark_messages_delivered(p_conversation_id UUID, p_recipient_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_catalog
AS $$
DECLARE
    v_actor_id UUID := COALESCE(auth.uid(), p_recipient_id);
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM conversations
        WHERE id = p_conversation_id
          AND (user_1_id = v_actor_id OR user_2_id = v_actor_id)
    ) THEN
        RAISE EXCEPTION 'Not authorized for this conversation';
    END IF;

    UPDATE messages
    SET status = 'delivered',
        delivered_at = COALESCE(delivered_at, NOW()),
        updated_at = NOW()
    WHERE conversation_id = p_conversation_id
      AND sender_id != v_actor_id
      AND status IN ('pending', 'sent');
END;
$$;

-- 3. mark_messages_read(p_conversation_id UUID, p_reader_id UUID) — bulk status update
CREATE OR REPLACE FUNCTION mark_messages_read(p_conversation_id UUID, p_reader_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_catalog
AS $$
DECLARE
    v_actor_id UUID := COALESCE(auth.uid(), p_reader_id);
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM conversations
        WHERE id = p_conversation_id
          AND (user_1_id = v_actor_id OR user_2_id = v_actor_id)
    ) THEN
        RAISE EXCEPTION 'Not authorized for this conversation';
    END IF;

    UPDATE messages
    SET status = 'read',
        delivered_at = COALESCE(delivered_at, NOW()),
        read_at = COALESCE(read_at, NOW()),
        updated_at = NOW()
    WHERE conversation_id = p_conversation_id
      AND sender_id != v_actor_id
      AND status != 'read';
END;
$$;

-- 4. handle_view_once_view(p_message_id UUID, p_viewer_id UUID)
-- nulls media URL, sets view_once_viewed = TRUE (restricted to type = 'view_once')
CREATE OR REPLACE FUNCTION handle_view_once_view(p_message_id UUID, p_viewer_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_catalog
AS $$
DECLARE
    v_actor_id UUID := COALESCE(auth.uid(), p_viewer_id);
BEGIN
    UPDATE messages m
    SET media_url = NULL,
        media_thumbnail_url = NULL,
        view_once_viewed = TRUE,
        view_once_viewed_at = NOW(),
        status = 'read',
        delivered_at = COALESCE(m.delivered_at, NOW()),
        read_at = COALESCE(m.read_at, NOW()),
        updated_at = NOW()
    FROM conversations c
    WHERE m.id = p_message_id
      AND c.id = m.conversation_id
      AND m.type = 'view_once'
      AND m.view_once_viewed = FALSE
      AND (c.user_1_id = v_actor_id OR c.user_2_id = v_actor_id)
      AND m.sender_id != v_actor_id;
END;
$$;

-- 5. cleanup_expired_messages() — deletes rows where expires_at < NOW()
CREATE OR REPLACE FUNCTION cleanup_expired_messages()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_catalog
AS $$
BEGIN
    DELETE FROM messages
    WHERE expires_at IS NOT NULL
      AND expires_at < NOW();
END;
$$;

-- 6. Auto-set disappearing message expiration on INSERT if conversation timer is active
CREATE OR REPLACE FUNCTION set_message_expiration()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_catalog
AS $$
DECLARE
    v_timer INTERVAL;
BEGIN
    SELECT disappearing_timer INTO v_timer
    FROM conversations
    WHERE id = NEW.conversation_id;

    IF v_timer IS NOT NULL THEN
        NEW.is_disappearing := TRUE;
        IF NEW.expires_at IS NULL THEN
            NEW.expires_at := NOW() + v_timer;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_set_message_expiration ON messages;
CREATE TRIGGER trigger_set_message_expiration
    BEFORE INSERT ON messages
    FOR EACH ROW EXECUTE FUNCTION set_message_expiration();

-- 7. update_updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_catalog
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_conversations_updated_at ON conversations;
CREATE TRIGGER update_conversations_updated_at
    BEFORE UPDATE ON conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_messages_updated_at ON messages;
CREATE TRIGGER update_messages_updated_at
    BEFORE UPDATE ON messages
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_typing_indicators_updated_at ON typing_indicators;
CREATE TRIGGER update_typing_indicators_updated_at
    BEFORE UPDATE ON typing_indicators
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_fcm_tokens_updated_at ON fcm_tokens;
CREATE TRIGGER update_fcm_tokens_updated_at
    BEFORE UPDATE ON fcm_tokens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();