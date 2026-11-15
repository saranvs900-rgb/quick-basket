-- Quick Basket - Supabase Schema
-- Run this in Supabase SQL Editor

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- =====================================================
-- PROFILES (extends auth.users)
-- =====================================================
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  email text,
  role text not null default 'customer' check (role in ('customer', 'admin', 'delivery_partner')),
  avatar_url text,
  created_at timestamptz default now()
);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, phone, email, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    new.phone,
    new.email,
    coalesce(new.raw_user_meta_data->>'role', 'customer')
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- =====================================================
-- CATEGORIES
-- =====================================================
create table if not exists public.categories (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  image_url text,
  sort_order int default 0,
  is_active boolean default true,
  created_at timestamptz default now()
);

-- =====================================================
-- PRODUCTS
-- =====================================================
create table if not exists public.products (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  description text,
  category_id uuid references public.categories(id),
  price numeric(10,2) not null,
  mrp numeric(10,2) default 0,
  unit text default '1 unit',
  image_urls text[] default '{}',
  stock int default 0,
  is_active boolean default true,
  tags text[] default '{}',
  created_at timestamptz default now()
);

create index if not exists products_category_idx on public.products(category_id);
create index if not exists products_active_idx on public.products(is_active);

-- =====================================================
-- ADDRESSES
-- =====================================================
create table if not exists public.addresses (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  label text default 'Home',
  full_address text not null,
  lat double precision,
  lng double precision,
  is_default boolean default false,
  created_at timestamptz default now()
);

-- =====================================================
-- CART ITEMS
-- =====================================================
create table if not exists public.cart_items (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  quantity int not null default 1 check (quantity > 0),
  created_at timestamptz default now(),
  unique(user_id, product_id)
);

-- =====================================================
-- ORDERS
-- =====================================================
create table if not exists public.orders (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id),
  status text not null default 'Order Placed',
  total_amount numeric(10,2) not null,
  delivery_fee numeric(10,2) default 0,
  discount numeric(10,2) default 0,
  final_amount numeric(10,2) not null,
  address jsonb,
  payment_id text,
  delivery_partner_id uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists orders_user_idx on public.orders(user_id);
create index if not exists orders_status_idx on public.orders(status);
create index if not exists orders_partner_idx on public.orders(delivery_partner_id);

-- =====================================================
-- ORDER ITEMS
-- =====================================================
create table if not exists public.order_items (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id),
  name text not null,
  price numeric(10,2) not null,
  quantity int not null,
  image_url text
);

-- =====================================================
-- DELIVERY PARTNERS (extra fields)
-- =====================================================
create table if not exists public.delivery_partners (
  id uuid primary key references public.profiles(id) on delete cascade,
  is_available boolean default true,
  vehicle text default 'Bike',
  earnings numeric(10,2) default 0,
  current_lat double precision,
  current_lng double precision,
  updated_at timestamptz default now()
);

-- =====================================================
-- COUPONS
-- =====================================================
create table if not exists public.coupons (
  id uuid primary key default uuid_generate_v4(),
  code text unique not null,
  discount_type text check (discount_type in ('percentage', 'flat')),
  value numeric(10,2) not null,
  min_order numeric(10,2) default 0,
  max_discount numeric(10,2),
  expires_at timestamptz,
  is_active boolean default true
);

-- =====================================================
-- PAYMENTS
-- =====================================================
create table if not exists public.payments (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid references public.orders(id),
  user_id uuid references public.profiles(id),
  amount numeric(10,2) not null,
  provider text default 'razorpay',
  provider_payment_id text,
  status text default 'pending',
  created_at timestamptz default now()
);

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================
alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.addresses enable row level security;
alter table public.cart_items enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.delivery_partners enable row level security;
alter table public.coupons enable row level security;
alter table public.payments enable row level security;

-- Helper: is admin
create or replace function public.is_admin()
returns boolean as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$ language sql security definer;

-- Profiles
create policy "Public profiles are viewable by authenticated users"
  on public.profiles for select to authenticated using (true);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

create policy "Admins can update any profile"
  on public.profiles for update using (public.is_admin());

-- Categories & Products - public read
create policy "Categories are public"
  on public.categories for select using (true);

create policy "Admins manage categories"
  on public.categories for all using (public.is_admin());

create policy "Products are public"
  on public.products for select using (true);

create policy "Admins manage products"
  on public.products for all using (public.is_admin());

-- Addresses
create policy "Users manage own addresses"
  on public.addresses for all using (auth.uid() = user_id);

-- Cart
create policy "Users manage own cart"
  on public.cart_items for all using (auth.uid() = user_id);

-- Orders
create policy "Users can view own orders"
  on public.orders for select using (
    auth.uid() = user_id
    or auth.uid() = delivery_partner_id
    or public.is_admin()
  );

create policy "Users can create orders"
  on public.orders for insert with check (auth.uid() = user_id);

create policy "Admins and partners can update orders"
  on public.orders for update using (
    public.is_admin()
    or auth.uid() = delivery_partner_id
    or (auth.uid() = user_id and status = 'Cancelled')
  );

-- Order items
create policy "Order items visible with order"
  on public.order_items for select using (
    exists (
      select 1 from public.orders o
      where o.id = order_id
        and (o.user_id = auth.uid() or o.delivery_partner_id = auth.uid() or public.is_admin())
    )
  );

create policy "Users can insert order items for own orders"
  on public.order_items for insert with check (
    exists (select 1 from public.orders o where o.id = order_id and o.user_id = auth.uid())
  );

-- Delivery partners
create policy "Partners readable by authenticated"
  on public.delivery_partners for select to authenticated using (true);

create policy "Partners update own record"
  on public.delivery_partners for all using (auth.uid() = id or public.is_admin());

-- Coupons
create policy "Coupons readable"
  on public.coupons for select to authenticated using (true);

create policy "Admins manage coupons"
  on public.coupons for all using (public.is_admin());

-- Payments
create policy "Users see own payments"
  on public.payments for select using (auth.uid() = user_id or public.is_admin());

create policy "Users create payments"
  on public.payments for insert with check (auth.uid() = user_id);

-- =====================================================
-- UPDATED_AT trigger for orders
-- =====================================================
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists orders_updated_at on public.orders;
create trigger orders_updated_at
  before update on public.orders
  for each row execute procedure public.set_updated_at();
