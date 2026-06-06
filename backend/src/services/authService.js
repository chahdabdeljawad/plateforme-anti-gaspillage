const bcrypt = require('bcrypt');

const {
  createClient,
  findClientByEmail,
  createStore,
  findStoreByEmail,
  createLivreur,        // 🚚
  findLivreurByEmail    // 🚚
} = require('../models/userModel');

const { generateToken } = require('../config/jwt');


// ================= REGISTER =================
const registerUser = async ({
  name, email, password, role, phone,
  storeCategory, latitude, longitude, placeName,
  vehicle   
}) => {

  let existing;


  if (role === "client") {
    existing = await findClientByEmail(email);
  } else if (role === "store") {
    existing = await findStoreByEmail(email);
  } else if (role === "livreur") {
    existing = await findLivreurByEmail(email);
  } else {
    throw new Error("Invalid role");
  }


  if (existing) {
    throw new Error("Email already exists");
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  let user;


  if (role === "client") {
    user = await createClient(name, email, hashedPassword, phone);
  } else if (role === "store") {
    user = await createStore(
      name, email, hashedPassword, phone,
      storeCategory, placeName, latitude, longitude, false
    );
  } else {
    //  LIVREUR
    user = await createLivreur(name, email, hashedPassword, phone, vehicle, latitude, longitude);
  }

  console.log("REGISTER USER =", user);
  const token = generateToken({ id: user.id, role });

  return { success: true, user: { ...user, role }, token };
};


// ================= LOGIN =================
const loginUser = async ({ email, password }) => {

  let user = await findClientByEmail(email);
  let role = "client";

  // 🏪 STORE
  if (!user) {
    user = await findStoreByEmail(email);
    role = "store";
  }

  // 🚚 LIVREUR
  if (!user) {
    user = await findLivreurByEmail(email);
    role = "livreur";
  }

  // ❌ STORE NOT VALIDATED
  if (user && user.is_validated === false) {
    throw new Error("Store waiting admin validation");
  }

  // ❌ NOT FOUND
  if (!user) {
    throw new Error("User not found");
  }

  // 🔐 PASSWORD
  const valid = await bcrypt.compare(password, user.password);
  if (!valid) {
    throw new Error("Invalid password");
  }

  console.log("LOGIN USER =", user);
  const token = generateToken({ id: user.id, role });

  return {
    success: true,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      num: user.num,
      role,
      // STORE ONLY
      categorie: user.categorie,
      localisation: user.localisation,
      latitude: user.latitude,
      longitude: user.longitude,
      // LIVREUR ONLY
      phone: user.phone,
      vehicle: user.vehicle,
    },
    token
  };
};


// ================= GET PROFILE =================
const getUserProfile = async (id, role) => {

  const pool = require('../config/db');
  let result;

  if (role === "client") {
    result = await pool.query(
      `SELECT id, name, email, num FROM clients WHERE id = $1`,
      [id]
    );
  } else if (role === "store") {
    result = await pool.query(
      `
      SELECT id, name, email, num, categorie, localisation, latitude, longitude
      FROM stores WHERE id = $1
      `,
      [id]
    );
  } else if (role === "livreur") {
    result = await pool.query(
      `
      SELECT id, name, email, phone, vehicle, status, latitude, longitude
      FROM livreurs WHERE id = $1
      `,
      [id]
    );
  }

  if (!result || result.rows.length === 0) {
    return null;
  }

  return { ...result.rows[0], role };
};


module.exports = {

  registerUser,

  loginUser,

  getUserProfile
};