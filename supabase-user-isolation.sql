-- Little Blossoms: per-user Supabase data isolation
-- Run this entire file once in Supabase SQL Editor.

create schema if not exists private;

create or replace function private.lb_is_admin()
returns boolean
language sql
security definer
set search_path = ''
stable
as $$
  select exists (
    select 1
    from public.user_roles
    where user_id = (select auth.uid())
      and role = 'admin'
  );
$$;

revoke execute on function private.lb_is_admin() from public;
grant usage on schema private to authenticated;
grant execute on function private.lb_is_admin() to authenticated;

alter table public.students
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists students_user_id_idx
  on public.students(user_id);

alter table public.students enable row level security;

grant select, insert, update, delete on public.students to authenticated;

create policy "LB students authenticated access"
  on public.students
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB students owner restriction"
  on public.students
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

alter table public.fee_payments
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists fee_payments_user_id_idx
  on public.fee_payments(user_id);

alter table public.fee_payments enable row level security;

grant select, insert, update, delete on public.fee_payments to authenticated;

create policy "LB fee_payments authenticated access"
  on public.fee_payments
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB fee_payments owner restriction"
  on public.fee_payments
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

alter table public.registration_payments
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists registration_payments_user_id_idx
  on public.registration_payments(user_id);

alter table public.registration_payments enable row level security;

grant select, insert, update, delete on public.registration_payments to authenticated;

create policy "LB registration_payments authenticated access"
  on public.registration_payments
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB registration_payments owner restriction"
  on public.registration_payments
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

alter table public.expenses
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists expenses_user_id_idx
  on public.expenses(user_id);

alter table public.expenses enable row level security;

grant select, insert, update, delete on public.expenses to authenticated;

create policy "LB expenses authenticated access"
  on public.expenses
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB expenses owner restriction"
  on public.expenses
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

alter table public.investments
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists investments_user_id_idx
  on public.investments(user_id);

alter table public.investments enable row level security;

grant select, insert, update, delete on public.investments to authenticated;

create policy "LB investments authenticated access"
  on public.investments
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB investments owner restriction"
  on public.investments
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

alter table public.balance_adjustments
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists balance_adjustments_user_id_idx
  on public.balance_adjustments(user_id);

alter table public.balance_adjustments enable row level security;

grant select, insert, update, delete on public.balance_adjustments to authenticated;

create policy "LB balance_adjustments authenticated access"
  on public.balance_adjustments
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB balance_adjustments owner restriction"
  on public.balance_adjustments
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

alter table public.dance_students
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists dance_students_user_id_idx
  on public.dance_students(user_id);

alter table public.dance_students enable row level security;

grant select, insert, update, delete on public.dance_students to authenticated;

create policy "LB dance_students authenticated access"
  on public.dance_students
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB dance_students owner restriction"
  on public.dance_students
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

alter table public.dance_fee_collections
  add column if not exists user_id uuid references auth.users(id) on delete cascade;

create index if not exists dance_fee_collections_user_id_idx
  on public.dance_fee_collections(user_id);

alter table public.dance_fee_collections enable row level security;

grant select, insert, update, delete on public.dance_fee_collections to authenticated;

create policy "LB dance_fee_collections authenticated access"
  on public.dance_fee_collections
  as permissive
  for all
  to authenticated
  using (true)
  with check (true);

create policy "LB dance_fee_collections owner restriction"
  on public.dance_fee_collections
  as restrictive
  for all
  to authenticated
  using (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  )
  with check (
    (select private.lb_is_admin())
    or
    ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  );

-- Existing rows with NULL user_id remain visible to Admin accounts only.
-- New records created by the updated app are automatically linked to auth.uid().


-- ============================================================
-- ADMIN-ONLY UPDATE / DELETE
-- Normal users may INSERT their own rows and SELECT their own rows,
-- but only users with role='admin' may UPDATE or DELETE any row.
-- ============================================================

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
    execute format('drop policy if exists "LB %s admin update only" on public.%I', t, t);
    execute format(
      'create policy "LB %s admin update only" on public.%I as restrictive for update to authenticated using ((select private.lb_is_admin())) with check ((select private.lb_is_admin()))',
      t, t
    );

    execute format('drop policy if exists "LB %s admin delete only" on public.%I', t, t);
    execute format(
      'create policy "LB %s admin delete only" on public.%I as restrictive for delete to authenticated using ((select private.lb_is_admin()))',
      t, t
    );
  end loop;
end $$;

-- IMPORTANT:
-- Run this SQL file once in Supabase SQL Editor.
-- The GitHub code alone cannot enforce database-level permissions.


-- ============================================================
-- SPECIAL STAFF ACCESS
-- littleblossom0111@gmail.com can VIEW admin-owned data and INSERT
-- new records, but cannot UPDATE or DELETE anything.
-- ============================================================

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
