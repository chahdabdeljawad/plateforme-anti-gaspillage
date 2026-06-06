const {
  createDelivery,
  getAvailableDeliveries,
  getLivreurDeliveries,
  acceptDelivery,
  updateDeliveryStatus,
  confirmDelivery,
} = require('../models/deliveryModel');

// ➕ CREATE (client demande livraison)
const create = async (req, res) => {
  try {
    const { id_reservation } = req.body;
    if (!id_reservation) {
      return res.status(400).json({ success: false, message: "id_reservation requis" });
    }
    const delivery = await createDelivery(id_reservation);
    res.status(201).json({ success: true, delivery });
  } catch (err) {
    console.error("CREATE DELIVERY ERROR =", err);
    res.status(500).json({ success: false, error: err.message });
  }
};

// 📋 DISPONIBLES
const getAvailable = async (req, res) => {
  try {
    const deliveries = await getAvailableDeliveries();
    res.json({ success: true, deliveries });
  } catch (err) {
    console.error("GET AVAILABLE ERROR =", err);
    res.status(500).json({ success: false, error: err.message });
  }
};

// 🚚 MES LIVRAISONS
const getMine = async (req, res) => {
  try {
    const { livreurId } = req.params;
    const deliveries = await getLivreurDeliveries(livreurId);
    res.json({ success: true, deliveries });
  } catch (err) {
    console.error("GET MY DELIVERIES ERROR =", err);
    res.status(500).json({ success: false, error: err.message });
  }
};

// ✅ ACCEPTER
const accept = async (req, res) => {
  try {
    const { id } = req.params;
    const { id_livreur } = req.body;
    const delivery = await acceptDelivery(id, id_livreur);
    if (!delivery) {
      return res.status(400).json({ success: false, message: "Livraison déjà prise ou introuvable" });
    }
    res.json({ success: true, delivery });
  } catch (err) {
    console.error("ACCEPT ERROR =", err);
    res.status(500).json({ success: false, error: err.message });
  }
};

// 🔄 STATUT
const updateStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const delivery = await updateDeliveryStatus(id, status);
    res.json({ success: true, delivery });
  } catch (err) {
    console.error("UPDATE STATUS ERROR =", err);
    res.status(500).json({ success: false, error: err.message });
  }
};

// 🏁 CONFIRMER
const confirm = async (req, res) => {
  try {
    const { id } = req.params;
    const delivery = await confirmDelivery(id);
    res.json({ success: true, delivery });
  } catch (err) {
    console.error("CONFIRM ERROR =", err);
    res.status(500).json({ success: false, error: err.message });
  }
};

module.exports = { create, getAvailable, getMine, accept, updateStatus, confirm };