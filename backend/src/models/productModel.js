const pool = require('../config/db');

// ➕ CREATE PRODUCT
const createProduct = async (
  name,
  price,
  old_price,
  description,
  category,
  image,
  store_id
) => {

  const result = await pool.query(
    `
    INSERT INTO products
    (
      name,
      price,
      old_price,
      description,
      category,
      image,
      store_id
    )

    VALUES($1,$2,$3,$4,$5,$6,$7)

    RETURNING *
    `,
    [
      name,
      price,
      old_price,
      description,
      category,
      image,
      store_id
    ]
  );

  return result.rows[0];
};

// 🔄 UPDATE PRODUCT
const updateProduct = async (
  id,
  name,
  price,
  old_price,
  description,
  category,
  image,
  store_id
) => {

  // ✅ GET OLD PRODUCT
  const oldProduct = await pool.query(
    `
    SELECT *
    FROM products
    WHERE id=$1
    `,
    [id]
  );

  if (oldProduct.rows.length === 0) {
    return null;
  }

  const finalImage =
      image ||
      oldProduct.rows[0].image;

  const result = await pool.query(
    `
    UPDATE products

    SET
      name=$1,
      price=$2,
      old_price=$3,
      description=$4,
      category=$5,
      image=$6

    WHERE id=$7

    RETURNING *
    `,
    [
      name,
      price,
      old_price,
      description,
      category,
      finalImage,
      id
    ]
  );

  return result.rows[0];
};

// 🗑 DELETE PRODUCT
const deleteProduct = async (
  id,
  store_id
) => {

  const result = await pool.query(
    `
    DELETE FROM products
    WHERE id=$1

    RETURNING *
    `,
    [id]
  );

  return result.rows[0];
};

// 📦 GET PRODUCTS BY STORE
const getProductsByStore = async (
  store_id
) => {

  const result = await pool.query(
    `
    SELECT *
    FROM products
    WHERE store_id=$1

    ORDER BY created_at DESC
    `,
    [store_id]
  );

  return result.rows;
};

// 🌍 GET ALL PRODUCTS
const getAllProducts = async () => {

  const result = await pool.query(
    `
    SELECT *
    FROM products
    ORDER BY created_at DESC
    `
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