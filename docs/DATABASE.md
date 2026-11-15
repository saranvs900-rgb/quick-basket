# Database Structure (Cloud Firestore)

## Collections

### users
```json
{
  "uid": "string",
  "role": "customer" | "admin" | "delivery_partner",
  "name": "string",
  "email": "string",
  "phone": "string",
  "photoUrl": "string",
  "createdAt": "timestamp",
  "fcmTokens": ["string"]
}
```

### categories
```json
{
  "id": "string",
  "name": "Fruits",
  "imageUrl": "string",
  "order": 1,
  "isActive": true
}
```

### products
```json
{
  "id": "string",
  "name": "Fresh Apples",
  "description": "string",
  "categoryId": "string",
  "price": 120.0,
  "mrp": 150.0,
  "unit": "1 kg",
  "imageUrls": ["string"],
  "stock": 50,
  "isActive": true,
  "tags": ["organic", "fresh"],
  "createdAt": "timestamp"
}
```

### carts
```json
{
  "userId": "string",
  "items": [
    {
      "productId": "string",
      "quantity": 2,
      "price": 120.0
    }
  ],
  "updatedAt": "timestamp"
}
```

### addresses
```json
{
  "userId": "string",
  "label": "Home",
  "fullAddress": "string",
  "lat": 12.97,
  "lng": 77.59,
  "isDefault": true
}
```

### orders
```json
{
  "id": "string",
  "userId": "string",
  "items": [...],
  "totalAmount": 450.0,
  "deliveryFee": 20.0,
  "discount": 30.0,
  "finalAmount": 440.0,
  "status": "Order Placed",
  "address": { ... },
  "paymentId": "string",
  "deliveryPartnerId": "string | null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "statusHistory": [
    { "status": "Order Placed", "at": "timestamp" }
  ]
}
```

### delivery_partners
```json
{
  "uid": "string",
  "name": "string",
  "phone": "string",
  "isAvailable": true,
  "currentLocation": { "lat": 0, "lng": 0 },
  "vehicle": "Bike",
  "earnings": 0
}
```

### assignments
```json
{
  "orderId": "string",
  "deliveryPartnerId": "string",
  "status": "assigned" | "accepted" | "rejected",
  "assignedAt": "timestamp"
}
```

### coupons
```json
{
  "code": "FRESH50",
  "discountType": "percentage" | "flat",
  "value": 50,
  "minOrder": 299,
  "maxDiscount": 100,
  "expiresAt": "timestamp",
  "isActive": true
}
```

### payments
```json
{
  "orderId": "string",
  "userId": "string",
  "amount": 440.0,
  "razorpayOrderId": "string",
  "razorpayPaymentId": "string",
  "status": "success" | "failed",
  "createdAt": "timestamp"
}
```

## Relationships

- `products.categoryId` → `categories.id`
- `orders.userId` → `users.uid`
- `orders.deliveryPartnerId` → `delivery_partners.uid`
- `carts.userId` → `users.uid`

## Indexes

Composite indexes will be required for queries such as:
- products by categoryId + isActive
- orders by userId + createdAt
- orders by status + createdAt

Deploy `firestore.indexes.json`.
