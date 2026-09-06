-- ============================================================
-- SAAMS SECURE DATABASE
-- ============================================================
--
-- This creates:
--
-- 1. admins
-- 2. readmission_applications
-- 3. Row Level Security
-- 4. Admin authorization
--
-- ============================================================


-- ============================================================
-- EXTENSION
-- ============================================================

create extension if not exists pgcrypto;



-- ============================================================
-- PRIVATE SCHEMA
-- ============================================================

create schema if not exists private;



-- ============================================================
-- ADMIN TABLE
-- ============================================================

create table if not exists public.admins (

    user_id uuid
        primary key
        references auth.users(id)
        on delete cascade,

    email text,

    created_at timestamptz
        not null
        default now()

);



-- ============================================================
-- READMISSION APPLICATIONS
-- ============================================================

create table if not exists
public.readmission_applications (

    id uuid
        primary key
        default gen_random_uuid(),


    application_number text
        not null
        unique
        default (

            'SAAMS-' ||

            upper(

                substr(

                    replace(
                        gen_random_uuid()::text,
                        '-',
                        ''
                    ),

                    1,
                    10

                )

            )

        ),


    full_name text
        not null,


    registration_number text
        not null,


    date_of_birth date
        not null,


    gender text
        not null,


    mobile text
        not null,


    email text,


    course text
        not null,


    year_semester text
        not null,


    previous_academic_status text,


    address text
        not null,


    city text
        not null,


    state text
        not null,


    created_at timestamptz
        not null
        default now()

);



-- ============================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================

alter table
public.admins
enable row level security;


alter table
public.readmission_applications
enable row level security;



-- ============================================================
-- ADMIN CHECK FUNCTION
-- ============================================================

create or replace function
private.is_admin()

returns boolean

language sql

security definer

set search_path = ''

stable

as $$

    select exists (

        select 1

        from public.admins

        where user_id =
            (select auth.uid())

    );

$$;



-- ============================================================
-- FUNCTION PERMISSIONS
-- ============================================================

revoke execute

on function
private.is_admin()

from public;


grant execute

on function
private.is_admin()

to authenticated;



-- ============================================================
-- ADMIN TABLE POLICY
-- ============================================================

drop policy if exists
"Admins can view their own admin record"

on public.admins;



create policy
"Admins can view their own admin record"

on public.admins

for select

to authenticated

using (

    (select auth.uid())
    =
    user_id

);



-- ============================================================
-- VISITOR INSERT POLICY
-- ============================================================

drop policy if exists
"Anyone can submit readmission applications"

on public.readmission_applications;



create policy
"Anyone can submit readmission applications"

on public.readmission_applications

for insert

to anon, authenticated

with check (

    length(
        trim(full_name)
    )
    between 2 and 120


    and


    length(
        trim(registration_number)
    )
    between 1 and 80


    and


    length(
        trim(mobile)
    )
    between 7 and 25


    and


    length(
        trim(course)
    )
    between 1 and 120


    and


    length(
        trim(year_semester)
    )
    between 1 and 80


    and


    length(
        trim(address)
    )
    between 3 and 500


    and


    length(
        trim(city)
    )
    between 1 and 100


    and


    length(
        trim(state)
    )
    between 1 and 100

);



-- ============================================================
-- ADMIN SELECT POLICY
-- ============================================================

drop policy if exists
"Only admins can view applications"

on public.readmission_applications;



create policy
"Only admins can view applications"

on public.readmission_applications

for select

to authenticated

using (

    (select private.is_admin())

);



-- ============================================================
-- ADMIN DELETE POLICY
-- ============================================================

drop policy if exists
"Only admins can delete applications"

on public.readmission_applications;



create policy
"Only admins can delete applications"

on public.readmission_applications

for delete

to authenticated

using (

    (select private.is_admin())

);



-- ============================================================
-- LEAST PRIVILEGE DATABASE GRANTS
-- ============================================================

revoke all

on table
public.readmission_applications

from anon, authenticated;


grant insert

on table
public.readmission_applications

to anon, authenticated;


grant select, delete

on table
public.readmission_applications

to authenticated;



revoke all

on table
public.admins

from anon, authenticated;


grant select

on table
public.admins

to authenticated;



-- ============================================================
-- INDEXES
-- ============================================================

create index if not exists
readmission_created_at_idx

on public.readmission_applications
(created_at desc);



create index if not exists
readmission_registration_number_idx

on public.readmission_applications
(registration_number);



-- ============================================================
-- ADD YOUR ADMIN ACCOUNT
-- ============================================================
--
-- IMPORTANT:
--
-- First create your administrator account in:
--
-- Supabase
-- → Authentication
-- → Users
-- → Add user
--
-- Then copy YOUR USER UUID.
--
-- After that, run this command separately:
--
--
-- insert into public.admins
-- (user_id, email)
-- values
-- (
--     'YOUR_AUTH_USER_UUID',
--     'your-admin-email@example.com'
-- );
--
--
-- NEVER put your password here.
--
-- ============================================================
