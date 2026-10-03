-- Special staff access for Little Blossoms
-- Account: littleblossom0111@gmail.com
--
-- This account can:
--   SELECT admin-owned rows + its own rows
--   INSERT its own rows
--   NOT UPDATE or DELETE rows
--
-- Admin accounts retain full access.

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

revoke execute on function private.lb_is_shared_staff() from public;
grant execute on function private.lb_is_shared_staff() to authenticated;

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
    execute format('drop policy if exists "LB %s owner restriction" on public.%I', t, t);

    execute format(
      'create policy "LB %s owner restriction" on public.%I as restrictive for all to authenticated using (
        (select private.lb_is_admin())
        or
        ((select auth.uid()) is not null and (select auth.uid()) = user_id)
        or
        (
          (select private.lb_is_shared_staff())
          and
          user_id in (
            select user_id
            from public.user_roles
            where role = ''admin''
          )
        )
      ) with check (
        (select private.lb_is_admin())
        or
        ((select auth.uid()) is not null and (select auth.uid()) = user_id)
      )',
      t, t
    );
  end loop;
end $$;
