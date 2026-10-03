-- Little Blossoms: restore legacy records to the Admin account
-- Run this ONCE in Supabase SQL Editor after the user-isolation migration.
-- This does NOT delete any records. It only assigns old NULL user_id records
-- to the first account whose role is 'admin'.

do $$
declare
    admin_id uuid;
begin
    select user_id
    into admin_id
    from public.user_roles
    where role = 'admin'
    order by user_id
    limit 1;

    if admin_id is null then
        raise exception 'No Admin user found in public.user_roles.';
    end if;

    update public.students
       set user_id = admin_id
     where user_id is null;

    update public.fee_payments
       set user_id = admin_id
     where user_id is null;

    update public.registration_payments
       set user_id = admin_id
     where user_id is null;

    update public.expenses
       set user_id = admin_id
     where user_id is null;

    update public.investments
       set user_id = admin_id
     where user_id is null;

    update public.balance_adjustments
       set user_id = admin_id
     where user_id is null;

    update public.dance_students
       set user_id = admin_id
     where user_id is null;

    update public.dance_fee_collections
       set user_id = admin_id
     where user_id is null;
end $$;

-- Existing September surplus/starting amounts are preserved.
-- Existing Dance Student records are preserved.
-- No DELETE statement is used in this migration.
