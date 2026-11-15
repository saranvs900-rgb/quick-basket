# Database Schema (Supabase PostgreSQL)

All tables live in the `public` schema.

## Tables

### profiles
Extends `auth.users`

| Column     | Type      | Notes                    |
|------------|-----------|--------------------------|
| id         | uuid      | PK, references auth.users|
| full_name  | text      |                          |
| phone      | text      |                          |
| email      | text      |                          |
| role       | text      | customer / admin / delivery_partner |
| avatar_url | text      |                          |
| created_at | timestamptz |                        |

### categories
| id | name | image_url | sort_order | is_active |

### products
| id | name | description | category_id | price | mrp | unit | image_urls (text[]) | stock | is_active | tags (text[]) | created_at |

### addresses
| id | user_id | label | full_address | lat | lng | is_default |

### carts / cart_items
Simple approach: `cart_items` table with user_id + product_id + quantity.

### orders
| id | user_id | status | total_amount | delivery_fee | discount | final_amount | address (jsonb) | payment_id | delivery_partner_id | created_at | updated_at |

### order_items
| id | order_id | product_id | name | price | quantity | image_url |

### delivery_partners
| id (uuid = profile id) | is_available | vehicle | earnings | current_lat | current_lng |

### coupons
| id | code | discount_type | value | min_order | max_discount | expires_at | is_active |

### payments
| id | order_id | user_id | amount | provider | provider_payment_id | status | created_at |

## Order Status Values

- Order Placed
- Order Confirmed
- Preparing Order
- Ready for Pickup
- Out for Delivery
- Delivered
- Cancelled

## Row Level Security

See `supabase/schema.sql` for full RLS policies.
