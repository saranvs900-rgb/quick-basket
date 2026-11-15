import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

/**
 * Example: Validate stock & calculate final amount server-side when order is created.
 * In production expand this into full order placement + payment verification.
 */
export const onOrderCreate = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const order = snap.data();
    if (!order) return;

    // Deduct stock (simplified)
    const batch = db.batch();
    for (const item of order.items || []) {
      const productRef = db.collection('products').doc(item.productId);
      const productSnap = await productRef.get();
      if (productSnap.exists) {
        const currentStock = productSnap.data()?.stock ?? 0;
        const newStock = Math.max(0, currentStock - (item.quantity || 1));
        batch.update(productRef, { stock: newStock });
      }
    }
    await batch.commit();

    // You can also send FCM notification here
    console.log(`Order ${context.params.orderId} created and stock updated`);
  });

/**
 * Placeholder for payment verification webhook (Razorpay)
 * Deploy as HTTPS function and set as webhook URL in Razorpay dashboard.
 */
export const razorpayWebhook = functions.https.onRequest(async (req, res) => {
  // TODO: Verify signature using Razorpay secret
  // Update payment + order status accordingly
  res.status(200).send('OK');
});

/**
 * Simple health check
 */
export const health = functions.https.onRequest((req, res) => {
  res.json({ status: 'ok', service: 'Quick Basket Functions' });
});
