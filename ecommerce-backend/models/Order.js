const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  id: { type: Number, required: true, unique: true },
  name: { type: String, required: true },
  phone: { type: String, required: true },
  city: { type: String, required: true },
  postalAddress: { type: String, required: true },
  productIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true }],
  orderPlaced: { type: Date, default: Date.now, required: true },
  orderProcessed: { type: Date },
  orderProcessedStatus: { type: Boolean, default: false },
  orderShipped: { type: Date },
  orderShippedStatus: { type: Boolean, default: false },
  outForDelivery: { type: Date },
  outForDeliveryStatus: { type: Boolean, default: false },
  delivered: { type: Date },
  deliveredStatus: { type: Boolean, default: false }
});

module.exports = mongoose.model('Order', orderSchema);
