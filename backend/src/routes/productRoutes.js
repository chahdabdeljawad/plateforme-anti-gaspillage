const express = require('express');
const router = express.Router();

const {
  create,
  getMine,
  getAll,
  updateOne,
  deleteOne  
} = require('../controllers/productController');

const { protect } = require('../middlewares/authMiddleware');

// ➕ STORE ONLY
router.post('/', protect, create);

// 📦 STORE PRODUCTS
router.get('/my', protect, getMine);

// 🔄 UPDATE PRODUCT
router.put('/:id', protect, updateOne);

// 🗑️ DELETE PRODUCT
router.delete('/:id', protect, deleteOne);

// 🌍 PUBLIC
router.get('/', getAll);

module.exports = router;