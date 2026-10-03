-- Little Blossoms: Special Staff Access
-- Staff email: littleblossom0111@gmail.com
--
-- Staff can:
--   * View Admin-owned records
--   * View their own records
--   * Add their own records
--   * NOT edit/delete records
--
-- Admin keeps full access.
-- Run this file AFTER supabase-user-isolation.sql and
-- AFTER restore-legacy-data-to-admin.sql.

create schema if not exists private;

create or replace function private.lb_is_shared_staff()
returns boolean
language sql
security definer
set search_path = ''
stable
as $$
  select lower(coalesce(
    (select email from auth.users where id = (select auth.uid())),
    ''
  )) = 'littleblossom0111@gmail.com';
$$;

create or replace function private.lb_is_admin_user(target_user_id uuid)
returns boolean
language sql
security definer
set search_path = ''
stable
as $$
  select exists (
    select 1
    from public.user_roles
    where user_id = target_user_id
      and role = 'admin'
  );
$$;

revoke execute on function private.lb_is_shared_staff() from public;
revoke execute on function private.lb_is_admin_user(uuid) from public;

grant usage on schema private to authenticated;
grant execute on function private.lb_is_shared_staff() to authenticated;
grant execute on function private.lb_is_admin_user(uuid) to authenticated;

do $$
declare
  t text;
begin
  foreach t in array array[
    'students',
    'fee_payments',
    'registration_payments',
    'expenses',
    'investments',
    'balance_adjustments',
    'dance_students',
    'dance_fee_collections'
  ]
  loop
    -- Replace the normal owner restriction with the shared-staff-aware rule.
    execute format(
      'drop policy if exists "LB %s owner restriction" on public.%I',
      t, t
    );

    execute format(
      'create policy "LB %s owner restriction" on public.%I
       as restrictive
       for all
       to authenticated
       using (
         (select private.lb_is_admin())
         or
         ((select auth.uid()) is not null and (select auth.uid()) = user_id)
         or
         (
           (select private.lb_is_shared_staff())
           and
           (select private.lb_is_admin_user(user_id))
         )
       )
       with check (
         (select private.lb_is_admin())
         or
         ((select auth.uid()) is not null and (select auth.uid()) = user_id)
       )',
      t, t
    );
  end loop;
end $$;
