require('dotenv').config();

const express = require("express");
const cors = require("./src/config/cors");
const pool = require('./src/config/db');

const app = express();

// Middleware
app.use(cors);
app.use(express.json());

// DB connection test
pool.connect()
  .then(() => console.log('✅ PostgreSQL connected'))
  .catch(err => console.error('❌ DB error:', err));

// Routes
const authRoutes = require("./src/routes/authRoutes");
app.use("/api/auth", authRoutes);

// Test route
app.get("/", (req, res) => {
  res.send("ZeroGaspi Backend 🚀");
});

// Port
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
