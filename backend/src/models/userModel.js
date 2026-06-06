const pool = require('../config/db');


// ================= CLIENT =================
const createClient = async (name, email, password, phone) => {
  const result = await pool.query(
    `
    INSERT INTO clients(name, email, password, num)
    VALUES($1,$2,$3,$4)
    RETURNING id, name, email, num
    `,
    [name, email, password, phone]
  );
  return result.rows[0];
};

const findClientByEmail = async (email) => {
  const result = await pool.query(
    `SELECT * FROM clients WHERE email = $1`,
    [email]
  );
  return result.rows[0];
};


// ================= STORE =================
const createStore = async (
  name, email, password, phone, storeCategory,
  placeName, latitude, longitude, isValidated
) => {
  const result = await pool.query(
    `
    INSERT INTO stores(
      name, email, password, num, categorie,
      localisation, latitude, longitude, is_validated
    )
    VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)
    RETURNING
      id, name, email, num, categorie,
      localisation, latitude, longitude, is_validated
    `,
    [name, email, password, phone, storeCategory, placeName, latitude, longitude, isValidated]
  );
  return result.rows[0];
};

const findStoreByEmail = async (email) => {
  const result = await pool.query(
    `SELECT * FROM stores WHERE email = $1`,
    [email]
  );
  return result.rows[0];
};


// ================= LIVREUR =================
const createLivreur = async (
  name, email, password, phone, vehicle, latitude, longitude
) => {
  const result = await pool.query(
    `
    INSERT INTO livreurs(
      name, email, password, phone, vehicle,
      latitude, longitude, status, created_at
    )
    VALUES($1,$2,$3,$4,$5,$6,$7,'available',NOW())
    RETURNING id, name, email, phone, vehicle, latitude, longitude, status, created_at
    `,
    [name, email, password, phone, vehicle, latitude, longitude]
  );
  return result.rows[0];
};

const findLivreurByEmail = async (email) => {
  const result = await pool.query(
    `SELECT * FROM livreurs WHERE email = $1`,
    [email]
  );
  return result.rows[0];
};


// ================= UPDATE CLIENT =================
const updateClient = async (id, name, email, num) => {
  const result = await pool.query(
    `
    UPDATE clients
    SET name = $1, email = $2, num = $3
    WHERE id = $4
    RETURNING *
    `,
    [name, email, num, id]
  );
  return result.rows[0];
};


// ================= UPDATE STORE =================
const updateStore = async (id, name, email, num, categorie, localisation) => {
  const result = await pool.query(
    `
    UPDATE stores
    SET name = $1, email = $2, num = $3, categorie = $4, localisation = $5
    WHERE id = $6
    RETURNING *
    `,
    [name, email, num, categorie, localisation, id]
  );
  return result.rows[0];
};


// ================= UPDATE LIVREUR =================
const updateLivreur = async (id, name, email, phone, vehicle) => {
  const result = await pool.query(
    `
    UPDATE livreurs
    SET name = $1, email = $2, phone = $3, vehicle = $4
    WHERE id = $5
    RETURNING id, name, email, phone, vehicle, status
    `,
    [name, email, phone, vehicle, id]
  );
  return result.rows[0];
};


module.exports = {
  createClient,
  findClientByEmail,
  createStore,
  findStoreByEmail,
  createLivreur,
  findLivreurByEmail,
  updateClient,
  updateStore,
  updateLivreur,
};
