const express = require('express');
const router = express.Router();

const multer = require('multer');
const path = require('path');

const {
  create,
  getMine,
  getAll,
  updateOne,
  deleteOne
} = require('../controllers/productController');

const { protect } = require('../middlewares/authMiddleware');


// STORAGE CONFIG
const storage = multer.diskStorage({

  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },

  filename: (req, file, cb) => {
    cb(
      null,
      Date.now() + path.extname(file.originalname)
    );
  },
});

const upload = multer({ storage });


// ➕ STORE ONLY
router.post(
  '/',
  (req, res, next) => {
    console.log("POST PRODUCTS WORKING");
    next();
  },
  protect,
  upload.single('image'),
  create
);

// 📦 STORE PRODUCTS
router.get('/my', protect, getMine);

// 🔄 UPDATE PRODUCT
router.put('/:id', protect, updateOne);

// 🗑️ DELETE PRODUCT
router.delete('/:id', protect, deleteOne);

// 🌍 PUBLIC
router.get('/', getAll);

module.exports = router;