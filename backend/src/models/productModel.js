const pool = require('../config/db');

// ➕ CREATE PRODUCT
const createProduct = async (name, price, description, category, store_id) => {
  const result = await pool.query(
    `INSERT INTO products(name, price, description, category, store_id)
     VALUES($1,$2,$3,$4,$5)
     RETURNING *`,
    [name, price, description, category, store_id]
  );

  return result.rows[0];
};

// 🔄 UPDATE PRODUCT
const updateProduct = async (id, name, price, description, category, store_id) => {
  const result = await pool.query(
    `UPDATE products 
     SET name=$1, price=$2, description=$3, category=$4
     WHERE id=$5 AND store_id=$6
     RETURNING *`,
    [name, price, description, category, id, store_id]
  );

  return result.rows[0];
};

// 🗑️ DELETE PRODUCT
const deleteProduct = async (id, store_id) => {
  const result = await pool.query(
    `DELETE FROM products 
     WHERE id=$1 AND store_id=$2
     RETURNING *`,
    [id, store_id]
  );

  return result.rows[0];
};

// 📦 GET PRODUCTS BY STORE
const getProductsByStore = async (store_id) => {
  const result = await pool.query(
    `SELECT * FROM products WHERE store_id=$1 ORDER BY created_at DESC`,
    [store_id]
  );

  return result.rows;
};

// 🌍 GET ALL PRODUCTS
const getAllProducts = async () => {
  const result = await pool.query(
    `SELECT * FROM products ORDER BY created_at DESC`
  );

  return result.rows;
};

module.exports = {
  createProduct,
  getProductsByStore,
  getAllProducts,
  updateProduct,
  deleteProduct
};