const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json()); // Middleware to parse JSON bodies

const port = process.env.PORT || 3000;

// MongoDB connection
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Routes
const productRoutes = require('./routes/productRoutes'); 
const orderRoutes = require('./routes/orderRoutes'); 

app.use('/api/products', productRoutes); 
app.use('/api/orders', orderRoutes);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
