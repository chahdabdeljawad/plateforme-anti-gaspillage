const {
  registerUser,
  loginUser,
  getUserProfile
} = require('../services/authService');


// ================= REGISTER =================
const register = async (req, res) => {

  try {

    console.log(
      "REGISTER BODY =",
      req.body
    );

    const data =
      await registerUser(req.body);

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

    const data =
      await loginUser(req.body);

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

    // ✅ DEBUG TOKEN USER
    console.log(
      "REQ.USER =",
      req.user
    );

    // ✅ CHECK TOKEN ID
    if (!req.user || !req.user.userId) {

      return res.status(400).json({
        success: false,
        message: "ID missing from token"
      });
    }

    // ✅ GET USER FROM DB
    const user =
      await getUserProfile(
        req.user.userId,
        req.user.role
      );

    console.log(
      "USER FROM DB =",
      user
    );

    // ❌ USER NOT FOUND
    if (!user) {

      return res.status(404).json({
        success: false,
        message: "User not found"
      });
    }

    // ✅ SUCCESS
    return res.status(200).json({
      success: true,
      user
    });

  } catch (err) {

    console.log(
      "GET ME ERROR =",
      err
    );

    return res.status(500).json({
      success: false,
      message: err.message
    });
  }
};


module.exports = {
  register,
  login,
  getMe
};