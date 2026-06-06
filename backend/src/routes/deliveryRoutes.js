const express = require('express');
const router = express.Router();

const {
  create,
  getAvailable,
  getMine,
  accept,
  updateStatus,
  confirm,
} = require('../controllers/deliveryController');

router.post('/', create);
router.get('/available', getAvailable);
router.get('/my/:livreurId', getMine);
router.put('/:id/accept', accept);
router.put('/:id/status', updateStatus);
router.put('/:id/confirm', confirm);

module.exports = router;