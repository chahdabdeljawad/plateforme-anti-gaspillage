const bcrypt = require('bcrypt');

const {
  createClient,
  findClientByEmail,
  createStore,
  findStoreByEmail
} = require('../models/userModel');

const { generateToken } = require('../config/jwt');


// ================= REGISTER =================
const registerUser = async ({
  name,
  email,
  password,
  role,
  phone,
  storeCategory,
  latitude,
  longitude,
  placeName
}) => {

  let existing;

  // 👤 CLIENT
  if (role === "client") {

    existing =
      await findClientByEmail(email);

  }

  // 🏪 STORE
  else if (role === "store") {

    existing =
      await findStoreByEmail(email);

  }

  else {

    throw new Error("Invalid role");
  }

  // EMAIL EXISTS
  if (existing) {

    throw new Error(
      "Email already exists"
    );
  }

  // HASH PASSWORD
  const hashedPassword =
    await bcrypt.hash(password, 10);

  let user;

  // 👤 CREATE CLIENT
  if (role === "client") {

    user = await createClient(
      name,
      email,
      hashedPassword
    );
  }

  // 🏪 CREATE STORE
  else {

    user = await createStore(
      name,
      email,
      hashedPassword,
      phone,
      storeCategory,
      placeName,
      latitude,
      longitude
    );
  }

  // TOKEN
  console.log("REGISTER USER =", user);
  const token = generateToken({
    id: user.id,
    role
  });

  return {

    success: true,

    user: {
      ...user,
      role
    },

    token
  };
};


// ================= LOGIN =================
const loginUser = async ({
  email,
  password
}) => {

  let user =
    await findClientByEmail(email);

  let role = "client";

  // 🏪 IF STORE
  if (!user) {

    user =
      await findStoreByEmail(email);

    role = "store";
  }

  // ❌ USER NOT FOUND
  if (!user) {

    throw new Error(
      "User not found"
    );
  }

  // 🔐 CHECK PASSWORD
  const valid =
    await bcrypt.compare(
      password,
      user.password
    );

  if (!valid) {

    throw new Error(
      "Invalid password"
    );
  }

  // TOKEN
  console.log("LOGIN USER =", user);
  const token = generateToken({
    id: user.id,
    role
  });

  return {

    success: true,

    user: {

      id: user.id,

      name: user.name,

      email: user.email,

      role
    },

    token
  };
};


// ================= GET PROFILE =================
const getUserProfile = async (
  id,
  role
) => {

  const pool =
    require('../config/db');

  let result;

  // 👤 CLIENT
  if (role === "client") {

    result = await pool.query(
      `
      SELECT
        id,
        name,
        email
      FROM clients
      WHERE id = $1
      `,
      [id]
    );
  }

  // 🏪 STORE
  else {

    result = await pool.query(
      `
      SELECT
        id,
        name,
        email,
        num,
        categorie,
        localisation,
        latitude,
        longitude
      FROM stores
      WHERE id = $1
      `,
      [id]
    );
  }

  // ❌ NOT FOUND
  if (result.rows.length === 0) {

    return null;
  }

  return {

    ...result.rows[0],

    role
  };
};


module.exports = {

  registerUser,

  loginUser,

  getUserProfile
};