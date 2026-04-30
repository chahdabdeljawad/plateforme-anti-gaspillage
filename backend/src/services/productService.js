const {
  createProduct,
  getProductsByStore,
  getAllProducts,
  updateProduct,
  deleteProduct
} = require('../models/productModel');

// ➕ ADD PRODUCT
const addProduct = async (data, user) => {
  if (user.role !== "store") {
    throw new Error("Only store can add products");
  }

  return await createProduct(
    data.name,
    data.price,
    data.description,
    data.category,
    user.id
  );
};

// 🔄 UPDATE PRODUCT
const update = async (id, data, user) => {
  if (user.role !== "store") throw new Error("Only store");

  return await updateProduct(
    id,
    data.name,
    data.price,
    data.description,
    data.category,
    user.id
  );
};

// 🗑️ DELETE PRODUCT
const remove = async (id, user) => {
  if (user.role !== "store") throw new Error("Only store");

  return await deleteProduct(id, user.id);
};

// 📦 STORE PRODUCTS
const myProducts = async (user) => {
  if (user.role !== "store") {
    throw new Error("Access denied");
  }

  return await getProductsByStore(user.id);
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