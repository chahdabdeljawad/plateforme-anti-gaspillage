require('dotenv').config();

const express = require("express");
const cors = require("cors");
const { v4: uuidv4 } = require('uuid');

const pool = require('./src/config/db');

const app = express();

// ================= MIDDLEWARE =================

app.use(cors());

app.use(express.json());

app.use(express.urlencoded({ extended: true }));

// ================= IMAGES =================

app.use('/uploads', express.static('uploads'));

// ================= DB CONNECTION =================

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

// PRODUCTS
const productRoutes = require("./src/routes/productRoutes");
app.use("/api/products", productRoutes);

// ================= CUSTOM API =================

// ================= CLIENTS =================

app.get('/api/clients', async (req, res) => {

  try {

    const result = await pool.query(
      'SELECT * FROM clients'
    );

    res.json(result.rows);

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// ================= STORES =================

app.get('/api/stores', async (req, res) => {

  try {

    const result = await pool.query(
      'SELECT * FROM stores'
    );

    res.json(result.rows);

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// ================= PRODUCTS =================

app.get('/api/products', async (req, res) => {

  try {

    const result = await pool.query(
      'SELECT * FROM products'
    );

    res.json(result.rows);

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// ================= GET ALL RESERVATIONS =================

app.get('/api/reservations', async (req, res) => {

  try {

    const result = await pool.query(
      'SELECT * FROM reservations ORDER BY id DESC'
    );

    res.json(result.rows);

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// ================= CLIENT RESERVATIONS =================

app.get('/api/client-reservations/:clientId', async (req, res) => {

  try {

    const { clientId } = req.params;

    const result = await pool.query(
      `
      SELECT *
      FROM reservations
      WHERE client_id = $1
      ORDER BY id DESC
      `,
      [clientId]
    );

    res.json({
      success: true,
      reservations: result.rows
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message
    });
  }
});

// ================= CREATE RESERVATION =================

app.post('/api/reservations', async (req, res) => {

  try {

    const {
      client_id,
      product_id,
      quantity
    } = req.body;

    // ================= GET CLIENT =================

    const clientResult = await pool.query(
      `
      SELECT *
      FROM clients
      WHERE id = $1
      `,
      [client_id]
    );

    // ================= GET PRODUCT =================

    const productResult = await pool.query(
      `
      SELECT *
      FROM products
      WHERE id = $1
      `,
      [product_id]
    );

    // ================= CHECK =================

    if (
      clientResult.rows.length === 0 ||
      productResult.rows.length === 0
    ) {

      return res.status(404).json({
        success: false,
        message: "Client ou produit introuvable",
      });
    }

    const client =
      clientResult.rows[0];

    const product =
      productResult.rows[0];

    // ================= QR UNIQUE =================

    const qrCode =
      uuidv4();

    // ================= INSERT =================

    const result = await pool.query(
      `
      INSERT INTO reservations
      (
        client_id,
        product_id,
        client_name,
        client_num,
        product_name,
        store_name,
        quantity,
        qr_code,
        status,
        reservation_date
      )

      VALUES
      (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        'pending',
        NOW()
      )

      RETURNING *
      `,
      [
        client_id,
        product_id,

        client.name,
        client.num,

        product.name,
        product.category,

        quantity,
        qrCode
      ]
    );

    res.json({
      success: true,
      reservation: result.rows[0],
    });

  } catch (err) {

    console.error(err);

    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

// ================= TEST ROUTE =================

app.get("/", (req, res) => {

  res.send("ZeroGaspi Backend 🚀");
});

// ================= PORT =================

const PORT =
  process.env.PORT || 5000;

app.listen(PORT, () => {

  console.log(
    `🚀 Server running on port ${PORT}`
  );
});