class AppConstants {
  static const String appName = 'Quick Basket';
  static const String tagline = 'Fresh Groceries. Fast Delivery.';

  static const List<String> defaultCategories = [
    'Fruits',
    'Vegetables',
    'Dairy Products',
    'Snacks',
    'Beverages',
    'Rice and Grains',
    'Personal Care',
    'Household Items',
  ];

  static const double defaultDeliveryFee = 20.0;
  static const double freeDeliveryAbove = 499.0;

  // Collection names
  static const String usersCol = 'users';
  static const String productsCol = 'products';
  static const String categoriesCol = 'categories';
  static const String cartsCol = 'carts';
  static const String ordersCol = 'orders';
  static const String addressesCol = 'addresses';
  static const String deliveryPartnersCol = 'delivery_partners';
  static const String assignmentsCol = 'assignments';
  static const String couponsCol = 'coupons';
  static const String paymentsCol = 'payments';
}
