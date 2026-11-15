-- Optional sample data for Quick Basket

insert into public.categories (name, sort_order) values
  ('Fruits', 1),
  ('Vegetables', 2),
  ('Dairy Products', 3),
  ('Snacks', 4),
  ('Beverages', 5),
  ('Rice and Grains', 6),
  ('Personal Care', 7),
  ('Household Items', 8)
on conflict do nothing;

-- Sample products (category_id will be null if you run before categories, or update later)
insert into public.products (name, description, price, mrp, unit, stock, is_active) values
  ('Fresh Apples', 'Crisp and sweet red apples', 120, 150, '1 kg', 50, true),
  ('Bananas', 'Ripe yellow bananas', 40, 50, '1 dozen', 80, true),
  ('Tomatoes', 'Farm fresh tomatoes', 30, 40, '1 kg', 60, true),
  ('Milk 1L', 'Full cream milk', 60, 65, '1 litre', 100, true),
  ('Potato Chips', 'Classic salted chips', 20, 25, '1 pack', 200, true),
  ('Orange Juice', '100% pure orange juice', 90, 110, '1 litre', 40, true),
  ('Basmati Rice', 'Premium long grain', 180, 220, '5 kg', 30, true),
  ('Shampoo', 'Gentle care shampoo', 199, 249, '200 ml', 45, true);
