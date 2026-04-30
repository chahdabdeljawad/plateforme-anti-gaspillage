const {
  addProduct,
  myProducts,
  allProducts,
  update,
  remove
} = require('../services/productService');

// ➕ ADD PRODUCT
const create = async (req, res) => {
  try {
    const product = await addProduct(req.body, req.user);

    res.status(201).json({
      success: true,
      product
    });

  } catch (err) {
    res.status(400).json({
      success: false,
      message: err.message
    });
  }
};

// 🔄 UPDATE PRODUCT
const updateOne = async (req, res) => {
  try {
    const product = await update(req.params.id, req.body, req.user);
    res.json(product);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// 🗑️ DELETE PRODUCT
const deleteOne = async (req, res) => {
  try {
    const product = await remove(req.params.id, req.user);
    res.json(product);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// 📦 MY PRODUCTS
const getMine = async (req, res) => {
  try {
    const products = await myProducts(req.user);

    res.json({
      success: true,
      products
    });

  } catch (err) {
    res.status(403).json({
      success: false,
      message: err.message
    });
  }
};

// 🌍 ALL PRODUCTS
const getAll = async (req, res) => {
  try {
    const products = await allProducts();

    res.json({
      success: true,
      products
    });

  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
};

module.exports = { 
    create, 
    getMine, 
    getAll, 
    updateOne,
    deleteOne 
};