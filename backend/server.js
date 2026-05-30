require('dotenv').config();

const express = require("express");
const cors = require("./src/config/cors");
const pool = require('./src/config/db');

const app = express();

// Middleware
app.use(cors);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// IMAGES
app.use('/uploads', express.static('uploads'));

// DB connection test
pool.connect()
  .then(() => console.log('✅ PostgreSQL connected'))
  .catch(err => console.error('❌ DB error:', err));

// ================= ROUTES =================

// AUTH
const authRoutes = require("./src/routes/authRoutes");
app.use("/api/auth", authRoutes);

// ADMIN
const adminRoutes = require('./src/routes/adminRoutes');
app.use('/api/admin', adminRoutes);

// PRODUCTS ROUTES
const productRoutes = require("./src/routes/productRoutes");
app.use("/api/products", productRoutes);

// ================= CUSTOM API =================

// CLIENTS
app.get('/api/clients', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM clients');

    res.json(result.rows);
  } catch (err) {
    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// STORES
app.get('/api/stores', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM stores');

    res.json(result.rows);
  } catch (err) {
    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// PRODUCTS
app.get('/api/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products');

    res.json(result.rows);
  } catch (err) {
    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// RESERVATIONS
app.get('/api/reservations', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM reservations');

    res.json(result.rows);
  } catch (err) {
    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// TEST ROUTE
app.get("/", (req, res) => {
  res.send("ZeroGaspi Backend 🚀");
});

// PORT
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
