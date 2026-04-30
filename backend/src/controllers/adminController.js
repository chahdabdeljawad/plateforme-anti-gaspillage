const db = require('../config/db'); // حسب config متاعك

exports.adminLogin = async (req, res) => {
  const { email, password } = req.body;

  try {
    const result = await db.query(
      "SELECT * FROM admins WHERE email = $1 AND password = $2",
      [email, password]
    );

    if (result.rows.length > 0) {
      res.json({
        success: true,
        admin: result.rows[0]
      });
    } else {
      res.json({
        success: false,
        message: "Invalid admin credentials"
      });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};