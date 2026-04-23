const bcrypt = require('bcrypt');
const {
  createClient,
  findClientByEmail,
  createStore,
  findStoreByEmail
} = require('../models/userModel');

const { generateToken } = require('../config/jwt');


// ================= REGISTER =================
const registerUser = async ({ name, email, password, role }) => {

  let existing;

  if (role === "client") {
    existing = await findClientByEmail(email);
  } else if (role === "store") {
    existing = await findStoreByEmail(email);
  } else {
    throw new Error("Invalid role");
  }

  if (existing) throw new Error('Email already exists');

  const hashedPassword = await bcrypt.hash(password, 10);

  let user;

  if (role === "client") {
    user = await createClient(name, email, hashedPassword);
  } else {
    user = await createStore(name, email, hashedPassword);
  }

  const token = generateToken({ id: user.id, role });

  return {
    user: { ...user, role },
    token
  };
};


// ================= LOGIN =================
const loginUser = async ({ email, password }) => {

  let user = await findClientByEmail(email);
  let role = "client";

  if (!user) {
    user = await findStoreByEmail(email);
    role = "store";
  }

  if (!user) throw new Error('User not found');

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) throw new Error('Invalid password');

  const token = generateToken({ id: user.id, role });

  return {
    user: { ...user, role },
    token
  };
};

// ================= GET PROFILE =================
const getUserProfile = async (id, role) => {

  const pool = require('../config/db');

  let result;

  if (role === "client") {
    result = await pool.query(
      "SELECT id, name, email FROM clients WHERE id=$1",
      [id]
    );
  } else {
    result = await pool.query(
      "SELECT id, name, email FROM stores WHERE id=$1",
      [id]
    );
  }

  return { ...result.rows[0], role };
};


module.exports = { registerUser, loginUser, getUserProfile };