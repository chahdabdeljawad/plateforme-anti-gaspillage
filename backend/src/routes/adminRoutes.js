const express = require('express');
const router = express.Router();

const {
  adminLogin,
  getPendingStores,
  validateStore,
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

// GET ALL PENDING STORES
router.get('/pending-stores', getPendingStores);

// VALIDATE STORE
router.put('/validate-store/:id', validateStore);

// DELETE STORE
router.delete('/delete-store/:id', deleteStore);

// DELETE PRODUCT
router.delete('/delete-product/:id', deleteProduct);

// DELETE CLIENT
router.delete('/delete-client/:id', deleteClient);

// DELETE RESERVATION
router.delete('/delete-reservation/:id', deleteReservation);

// EXPORT CLIENTS CSV
router.get('/export-clients', exportClientsCSV);

// EXPORT STORES CSV
router.get('/export-stores', exportStoresCSV);

// EXPORT PRODUCTS CSV
router.get('/export-products', exportProductsCSV);

// EXPORT RESERVATIONS CSV
router.get('/export-reservations', exportReservationsCSV);

// GET REPORTS
router.get('/reports', getReports);

// DELETE REPORT
router.delete('/delete-report/:id', deleteReport);

// GET REVIEWS
router.get('/reviews', getReviews);

// DELETE REVIEW
router.delete('/delete-review/:id', deleteReview);

// GET STATISTICS
router.get('/statistics', getStatistics);

module.exports = router;