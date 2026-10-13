-- Read-only checks; SQL Editor uses privileged role, so it does NOT test RLS isolation.
SELECT c.relname AS table_name,c.relrowsecurity AS rls_enabled
FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
WHERE n.nspname='public' AND c.relname IN
 ('body_arena_admins','body_arena_profiles','body_arena_progress','body_arena_characters');
SELECT tablename,policyname,roles,cmd,qual,with_check FROM pg_policies
WHERE schemaname='public' AND tablename LIKE 'body_arena_%' ORDER BY tablename,policyname;
SELECT table_name,grantee,privilege_type FROM information_schema.role_table_grants
WHERE table_schema='public' AND table_name LIKE 'body_arena_%'
 AND grantee IN ('anon','authenticated') ORDER BY table_name,grantee,privilege_type;
SELECT id,name,enabled FROM public.body_arena_characters ORDER BY sort_order;
