const express = require('express');
const router = express.Router();
const Product = require('../models/Product');

// POST route to add a new product
router.post('/', async (req, res) => {
  try {
    const newProduct = new Product(req.body);
    const savedProduct = await newProduct.save();
    res.status(201).send(savedProduct);
  } catch (err) {
    res.status(400).send(err);
  }
});

// GET route to fetch all products
router.get('/', async (req, res) => {
  try {
    const products = await Product.find({});
    res.status(200).send(products);
  } catch (err) {
    res.status(500).send(err);
  }
});

// GET route to fetch a product by ID
router.get('/:id', async (req, res) => {
    try {
        const product = await Product.findById(req.params.id);
        if (product) {
            res.status(200).json(product);
        } else {
            res.status(404).send('Product not found');
        }
    } catch (error) {
        res.status(500).send('Server error');
    }
});

module.exports = router;
