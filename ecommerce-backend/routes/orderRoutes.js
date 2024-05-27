const express = require('express');
const router = express.Router();
const Order = require('../models/Order');

// POST route to add a new order
router.post('/', async (req, res) => {
  try {
    const latestOrder = await Order.findOne().sort({ id: -1 });
    const newOrderId = latestOrder ? latestOrder.id + 1 : 1;

    const newOrder = new Order({
      id: newOrderId,
      name: req.body.name,
      phone: req.body.phone,
      city: req.body.city,
      postalAddress: req.body.postalAddress,
      productIds: req.body.productIds,
      orderPlaced: new Date(),
      orderProcessedStatus: false,
      orderShippedStatus: false,
      outForDeliveryStatus: false,
      deliveredStatus: false
    });

    const savedOrder = await newOrder.save();
    res.status(201).json(savedOrder);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// GET route to fetch all orders
router.get('/', async (req, res) => {
  try {
    const orders = await Order.find({});
    res.status(200).json(orders);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET route to fetch a specific order by custom id
router.get('/:id', async (req, res) => {
  try {
    const order = await Order.findOne({ id: req.params.id });
    if (order) {
      res.status(200).json(order);
    } else {
      res.status(404).json({ error: 'Order not found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT route to update an order by custom id
router.put('/:id', async (req, res) => {
  try {
    const order = await Order.findOneAndUpdate({ id: req.params.id }, req.body, { new: true, runValidators: true });
    if (order) {
      res.status(200).json(order);
    } else {
      res.status(404).json({ error: 'Order not found' });
    }
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// DELETE route to delete an order by custom id
router.delete('/:id', async (req, res) => {
  try {
    const order = await Order.findOneAndDelete({ id: req.params.id });
    if (order) {
      res.status(200).json({ message: 'Order deleted' });
    } else {
      res.status(404).json({ error: 'Order not found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PATCH route to update the status of an order
router.patch('/:id/status', async (req, res) => {
  const { status, date } = req.body;
  const validStatuses = ['orderProcessedStatus', 'orderShippedStatus', 'outForDeliveryStatus', 'deliveredStatus'];

  if (!validStatuses.includes(status)) {
    return res.status(400).json({ error: 'Invalid status field' });
  }

  try {
    const update = {
      [status]: true,
      [`${status.replace('Status', '')}`]: date || new Date()
    };

    const order = await Order.findOneAndUpdate(
      { id: req.params.id },
      { $set: update },
      { new: true, runValidators: true }
    );

    if (order) {
      res.status(200).json(order);
    } else {
      res.status(404).json({ error: 'Order not found' });
    }
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
