const pool = require('../config/db');

// ➕ CREATE (statut pending, sans livreur)
const createDelivery = async (id_reservation) => {
  const result = await pool.query(
    `
    INSERT INTO deliveries (id_reservation, status)
    VALUES ($1, 'pending')
    RETURNING *
    `,
    [id_reservation]
  );
  return result.rows[0];
};

// 📋 LIVRAISONS DISPONIBLES (pending + pas encore prises)
const getAvailableDeliveries = async () => {
  const result = await pool.query(
    `
    SELECT
      d.id_delivery, d.status, d.delivery_date, d.id_reservation,
      r.client_name, r.client_num, r.product_name, r.store_name, r.quantity
    FROM deliveries d
    JOIN reservations r ON d.id_reservation = r.id
    WHERE d.status = 'pending' AND d.id_livreur IS NULL
    ORDER BY d.id_delivery DESC
    `
  );
  return result.rows;
};

// 🚚 MES LIVRAISONS (assignées à ce livreur)
const getLivreurDeliveries = async (id_livreur) => {
  const result = await pool.query(
    `
    SELECT
      d.id_delivery, d.status, d.delivery_date, d.id_reservation,
      r.client_name, r.client_num, r.product_name, r.store_name, r.quantity
    FROM deliveries d
    JOIN reservations r ON d.id_reservation = r.id
    WHERE d.id_livreur = $1
    ORDER BY d.id_delivery DESC
    `,
    [id_livreur]
  );
  return result.rows;
};

// ✅ ACCEPTER
const acceptDelivery = async (id_delivery, id_livreur) => {
  const result = await pool.query(
    `
    UPDATE deliveries
    SET id_livreur = $2, status = 'accepted'
    WHERE id_delivery = $1 AND status = 'pending'
    RETURNING *
    `,
    [id_delivery, id_livreur]
  );
  return result.rows[0];
};

// 🔄 STATUT (ex: in_progress)
const updateDeliveryStatus = async (id_delivery, status) => {
  const result = await pool.query(
    `
    UPDATE deliveries SET status = $2
    WHERE id_delivery = $1
    RETURNING *
    `,
    [id_delivery, status]
  );
  return result.rows[0];
};

// 🏁 CONFIRMER
const confirmDelivery = async (id_delivery) => {
  const result = await pool.query(
    `
    UPDATE deliveries
    SET status = 'delivered', delivery_date = NOW()
    WHERE id_delivery = $1
    RETURNING *
    `,
    [id_delivery]
  );
  return result.rows[0];
};

module.exports = {
  createDelivery,
  getAvailableDeliveries,
  getLivreurDeliveries,
  acceptDelivery,
  updateDeliveryStatus,
  confirmDelivery,
};