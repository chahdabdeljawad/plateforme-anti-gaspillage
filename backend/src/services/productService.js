const {
  createProduct,
  getProductsByStore,
  getAllProducts,
  updateProduct,
  deleteProduct
} = require('../models/productModel');

// ➕ ADD PRODUCT
const addProduct = async (data, file, user) => {

  if (user.role !== "store") {
    throw new Error("Only store can add products");
  }

  return await createProduct(
    data.name,
    data.price,
    data.oldPrice,
    data.description,
    data.category,
    file ? file.filename : null,
    Number(user.userId),
    data.expirationDate || null,                 // 🆕
    data.quantity ? Number(data.quantity) : 1    // 🆕
  );
};

// 🔄 UPDATE PRODUCT
const update = async (id, data, user) => {

  if (user.role !== "store") {
    throw new Error("Only store");
  }

  return await updateProduct(
    Number(id),
    data.name,
    data.price,
    data.oldPrice,
    data.description,
    data.category,
    data.image,
    Number(user.userId),
    data.expirationDate || null,                  // 🆕
    data.quantity ? Number(data.quantity) : null  // 🆕
  );
};

// 🗑️ DELETE PRODUCT
const remove = async (id, user) => {

  if (user.role !== "store") {
    throw new Error("Only store");
  }

  return await deleteProduct(
    Number(id),
    Number(user.userId)
  );
};

// 📦 STORE PRODUCTS
const myProducts = async (user) => {

  if (user.role !== "store") {
    throw new Error("Access denied");
  }

  return await getProductsByStore(
    Number(user.userId)
  );
};

// 🌍 ALL PRODUCTS
const allProducts = async () => {
  return await getAllProducts();
};

module.exports = {
  addProduct,
  myProducts,
  allProducts,
  update,
  remove
};