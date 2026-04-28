const pool = require('../config/db');


// ================= CLIENT =================
const createClient = async (name, email, password) => {
  const result = await pool.query(
    `INSERT INTO clients(name, email, password)
     VALUES($1,$2,$3)
     RETURNING id, name, email`,
    [name, email, password]
  );

  return result.rows[0];
};

const findClientByEmail = async (email) => {
  const result = await pool.query(
    'SELECT * FROM clients WHERE email=$1',
    [email]
  );

  return result.rows[0];
};


// ================= STORE =================
const createStore = async (name, email, password) => {
  const result = await pool.query(
    `INSERT INTO stores(name, email, password)
     VALUES($1,$2,$3)
     RETURNING id, name, email`,
    [name, email, password]
  );

  return result.rows[0];
};

const findStoreByEmail = async (email) => {
  const result = await pool.query(
    'SELECT * FROM stores WHERE email=$1',
    [email]
  );

  return result.rows[0];
};


module.exports = {
  createClient,
  findClientByEmail,
  createStore,
  findStoreByEmail
};