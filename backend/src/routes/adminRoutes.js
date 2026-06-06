const express = require('express');
const router = express.Router();

const {
  adminLogin,
  getPendingStores,
  validateStore,
  getPendingProducts,   // 🆕
  validateProduct,      // 🆕
  deleteStore,
  deleteProduct,
  deleteClient,
  deleteReservation,
  exportClientsCSV,
  exportStoresCSV,
  exportProductsCSV,
  exportReservationsCSV,
  getReports,
  deleteReport,
  getReviews,
  deleteReview,
  getStatistics
} = require('../controllers/adminController');

router.post('/login', adminLogin);

// STORES
router.get('/pending-stores', getPendingStores);


router.put('/validate-store/:id', validateStore);

// PRODUCTS 🆕
router.get('/pending-products', getPendingProducts);
router.put('/validate-product/:id', validateProduct);

// DELETE
router.delete('/delete-store/:id', deleteStore);


router.delete('/delete-product/:id', deleteProduct);


router.delete('/delete-client/:id', deleteClient);


router.delete('/delete-reservation/:id', deleteReservation);

// EXPORT CSV
router.get('/export-clients', exportClientsCSV);


router.get('/export-stores', exportStoresCSV);


router.get('/export-products', exportProductsCSV);


router.get('/export-reservations', exportReservationsCSV);

// REPORTS
router.get('/reports', getReports);


router.delete('/delete-report/:id', deleteReport);

// REVIEWS
router.get('/reviews', getReviews);


router.delete('/delete-review/:id', deleteReview);

// STATISTICS
router.get('/statistics', getStatistics);

module.exports = router;