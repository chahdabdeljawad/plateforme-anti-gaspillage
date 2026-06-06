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


const authRoutes = require("./src/routes/authRoutes");
app.use("/api/auth", authRoutes);


const adminRoutes = require('./src/routes/adminRoutes');
app.use('/api/admin', adminRoutes);

// 🆕 PRODUITS VALIDÉS (client) — AVANT le mount productRoutes
app.get('/api/products/validated', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM products WHERE is_validated = true ORDER BY created_at DESC`
    );
    res.json({ success: true, products: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

const productRoutes = require("./src/routes/productRoutes");
app.use("/api/products", productRoutes);

const deliveryRoutes = require("./src/routes/deliveryRoutes");
app.use("/api/deliveries", deliveryRoutes);

// ================= CLIENTS =================

app.get('/api/clients', async (req, res) => {

  try {
    const result = await pool.query('SELECT * FROM clients');
    res.json(result.rows);

  } catch (err) {

    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= STORES =================

app.get('/api/stores', async (req, res) => {

  try {
    const result = await pool.query('SELECT * FROM stores');
    res.json(result.rows);

  } catch (err) {

    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= PRODUCTS (admin = tout) =================
app.get('/api/products', async (req, res) => {
 
  try {
    const result = await pool.query('SELECT * FROM products');
    res.json(result.rows);

  } catch (err) {

    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= GET ALL RESERVATIONS =================

app.get('/api/reservations', async (req, res) => {
 
  try {
    const result = await pool.query('SELECT * FROM reservations ORDER BY id DESC');
    res.json(result.rows);
    
  } catch (err) {

    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= CLIENT RESERVATIONS =================

app.get('/api/client-reservations/:clientId', async (req, res) => {
 
  try {

    const { clientId } = req.params;
    const result = await pool.query(
      `SELECT * FROM reservations WHERE client_id = $1 ORDER BY id DESC`,
      [clientId]
    );
    res.json({ success: true, reservations: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= STORE RESERVATIONS =================
app.get('/api/store-reservations/:storeId', async (req, res) => {
  try {
    const { storeId } = req.params;
    const result = await pool.query(
      `
      SELECT r.*, p.price AS product_price,
             CASE WHEN d.id_delivery IS NOT NULL THEN 'livraison' ELSE 'sur_place' END AS delivery_type
      FROM reservations r
      JOIN products p ON r.product_id = p.id
      LEFT JOIN deliveries d ON d.id_reservation = r.id
      WHERE p.store_id = $1
      ORDER BY r.id DESC
      `,
      [storeId]
    );
    res.json({ success: true, reservations: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= UPDATE RESERVATION STATUS =================
app.put('/api/reservations/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const result = await pool.query(
      `UPDATE reservations SET status = $1 WHERE id = $2 RETURNING *`,
      [status, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: "Réservation introuvable" });
    }
    res.json({ success: true, reservation: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= VERIFY QR =================
app.post('/api/reservations/verify-qr', async (req, res) => {
  try {
    const { qr_code } = req.body;

    const found = await pool.query(
      `SELECT * FROM reservations WHERE qr_code = $1`,
      [qr_code]
    );

    if (found.rows.length === 0) {
      return res.status(404).json({ success: false, message: "QR invalide ❌" });
    }

    const reservation = found.rows[0];

    if (reservation.status === 'completed') {
      return res.json({ success: false, message: "Déjà récupéré ✅", reservation });
    }

    const updated = await pool.query(
      `UPDATE reservations SET status = 'completed' WHERE qr_code = $1 RETURNING *`,
      [qr_code]
    );

    res.json({
      success: true,
      message: `Récupéré : ${reservation.product_name} ✅`,
      reservation: updated.rows[0]
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= REVIEWS (avis) =================
app.post('/api/reviews', async (req, res) => {
  try {
    const { client_name, store_name, comment, rating } = req.body;
    const result = await pool.query(
      `INSERT INTO reviews (client_name, store_name, comment, rating, created_at)
       VALUES ($1,$2,$3,$4,NOW()) RETURNING *`,
      [client_name, store_name, comment, rating]
    );
    res.status(201).json({ success: true, review: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/reviews/:storeName', async (req, res) => {
  try {
    const { storeName } = req.params;
    const result = await pool.query(
      `SELECT * FROM reviews WHERE store_name = $1 ORDER BY id DESC`,
      [storeName]
    );
    res.json({ success: true, reviews: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= REPORTS (signalement) =================
app.post('/api/reports', async (req, res) => {
  try {
    const { review_id, reason } = req.body;
    const result = await pool.query(
      `INSERT INTO reports (review_id, reason, created_at)
       VALUES ($1,$2,NOW()) RETURNING *`,
      [review_id, reason]
    );
    res.status(201).json({ success: true, report: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= CREATE RESERVATION =================

app.post('/api/reservations', async (req, res) => {
 
  try {
    const { client_id, product_id, quantity } = req.body;

    const clientResult = await pool.query(
      `SELECT * FROM clients WHERE id = $1`,
      [client_id]
    );



    const productResult = await pool.query(
      `SELECT * FROM products WHERE id = $1`,
      [product_id]
    );

    if (clientResult.rows.length === 0 || productResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Client ou produit introuvable",
      });
    }

    const client = clientResult.rows[0];
    const product = productResult.rows[0];

    const qrCode = uuidv4();

    const result = await pool.query(
      `
      INSERT INTO reservations
      (client_id, product_id, client_name, client_num, product_name,
       store_name, quantity, qr_code, status, reservation_date)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,'pending',NOW())
      RETURNING *
      `,
      [
        client_id, product_id,
        client.name, client.num,
        product.name, product.category,
        quantity, qrCode
      ]
    );

    res.json({ success: true, reservation: result.rows[0] });
  } catch (err) {

    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ================= TEST ROUTE =================

app.get("/", (req, res) => {

  res.send("ZeroGaspi Backend 🚀");
});

// ================= PORT =================
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});