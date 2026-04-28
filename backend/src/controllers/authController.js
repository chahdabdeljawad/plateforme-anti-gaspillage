const { registerUser, loginUser, getUserProfile } = require('../services/authService');

// ================= REGISTER =================
const register = async (req, res) => {
  try {
    console.log("📥 REGISTER BODY:", req.body); // 🔥 مهم برشا

    const data = await registerUser(req.body);

    res.status(201).json(data);

  } catch (err) {
    console.error("❌ REGISTER ERROR:", err.message); // 🔥 مهم

    res.status(400).json({
      success: false,
      message: err.message
    });
  }
};


// ================= LOGIN =================
const login = async (req, res) => {
  try {
    console.log("📥 LOGIN BODY:", req.body); // 🔥

    const data = await loginUser(req.body);

    res.json({
      success: true,
      ...data
    });

  } catch (err) {
    console.error("❌ LOGIN ERROR:", err.message); // 🔥

    res.status(400).json({
      success: false,
      message: err.message
    });
  }
};

// ================= PROFILE =================
const getMe = async (req, res) => {
  try {
    const user = await getUserProfile(req.user.id, req.user.role);
    res.json({       success: true,
          user });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { register, login, getMe };