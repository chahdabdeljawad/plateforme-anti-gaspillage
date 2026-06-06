const {
  registerUser,
  loginUser,
  getUserProfile
} = require('../services/authService');

const {
  updateClient,
  updateStore,
  updateLivreur
} = require('../models/userModel');


// ================= REGISTER =================
const register = async (req, res) => {
  try {
    console.log("REGISTER BODY =", req.body);

    const data = await registerUser(req.body);

    return res.status(201).json({
      success: true,
      ...data
    });
  } catch (err) {
    console.log("REGISTER ERROR =", err);
    return res.status(400).json({
      success: false,
      message: err.message
    });
  }
};


// ================= LOGIN =================
const login = async (req, res) => {
  try {
    const data = await loginUser(req.body);

    return res.status(200).json({
      success: true,
      ...data
    });
  } catch (err) {
    console.log("LOGIN ERROR =", err);
    return res.status(400).json({
      success: false,
      message: err.message
    });
  }
};


// ================= GET PROFILE =================
const getMe = async (req, res) => {
  try {
    console.log("REQ.USER =", req.user);

    if (!req.user || !req.user.userId) {
      return res.status(400).json({
        success: false,
        message: "ID missing from token"
      });
    }

    const user = await getUserProfile(
      req.user.userId,
      req.user.role
    );

    console.log("USER FROM DB =", user);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found"
      });
    }

    return res.status(200).json({
      success: true,
      user
    });
  } catch (err) {
    console.log("GET ME ERROR =", err);
    return res.status(500).json({
      success: false,
      message: err.message
    });
  }
};


// ================= UPDATE PROFILE =================
const updateProfile = async (req, res) => {
  try {
    const {
      id,
      role,
      name,
      email,
      num,
      categorie,
      localisation,
      phone,      // 🚚
      vehicle     // 🚚
    } = req.body;

    let updatedUser;

    // 👤 CLIENT
    if (role === "client") {
      updatedUser = await updateClient(id, name, email, num);
    }
    // 🏪 STORE
    else if (role === "store") {
      updatedUser = await updateStore(id, name, email, num, categorie, localisation);
    }
    // 🚚 LIVREUR
    else if (role === "livreur") {
      updatedUser = await updateLivreur(id, name, email, phone, vehicle);
    }

    return res.status(200).json({
      success: true,
      user: updatedUser
    });
  } catch (err) {
    console.log("UPDATE PROFILE ERROR =", err);
    return res.status(500).json({
      success: false,
      message: err.message
    });
  }
};


module.exports = {
  register,
  login,
  getMe,
  updateProfile
};